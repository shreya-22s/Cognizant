from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Department, Student, Course, Enrollment

engine = create_engine(
    "postgresql+psycopg2://postgres:Rit05Sy$l@localhost:5432/college_db_orm",
    echo=False
)

Session = sessionmaker(bind=engine)
session = Session()

# Departments
cs = Department(department_name="Computer Science")
it = Department(department_name="Information Technology")
ece = Department(department_name="Electronics")

session.add_all([cs, it, ece])
session.commit()

# Students
students = [
    Student(
        first_name="Shreya",
        last_name="R",
        email="shreya@gmail.com",
        enrollment_year=2023,
        department=cs
    ),
    Student(
        first_name="Priya",
        last_name="K",
        email="priya@gmail.com",
        enrollment_year=2022,
        department=cs
    ),
    Student(
        first_name="Rahul",
        last_name="S",
        email="rahul@gmail.com",
        enrollment_year=2021,
        department=it
    ),
    Student(
        first_name="Arun",
        last_name="M",
        email="arun@gmail.com",
        enrollment_year=2023,
        department=ece
    ),
    Student(
        first_name="Divya",
        last_name="P",
        email="divya@gmail.com",
        enrollment_year=2022,
        department=cs
    )
]

session.add_all(students)
session.commit()




courses = [
    Course(course_code="CS101", course_name="DBMS", credits=4),
    Course(course_code="CS102", course_name="Python", credits=3),
    Course(course_code="CS103", course_name="AI", credits=4)
]

session.add_all(courses)
session.commit()

enrollments = [
    Enrollment(student=students[0], course=courses[0]),
    Enrollment(student=students[1], course=courses[1]),
    Enrollment(student=students[2], course=courses[2]),
    Enrollment(student=students[4], course=courses[0])
]

session.add_all(enrollments)
session.commit()






cs_students = (
    session.query(Student)
    .join(Department)
    .filter(Department.department_name == "Computer Science")
    .all()
)

print("\nComputer Science Students:")
for s in cs_students:
    print(s.first_name, s.last_name)








print("\nEnrollments:")

enrollments = session.query(Enrollment).all()

for e in enrollments:
    print(
        e.student.first_name,
        "->",
        e.course.course_name
    )







student = (
    session.query(Student)
    .filter(Student.email == "shreya@gmail.com")
    .first()
)

student.enrollment_year = 2024

session.commit()

print("Student updated")

print(student.first_name, student.enrollment_year)









enrollment = session.query(Enrollment).first()

session.delete(enrollment)

session.commit()

print("Enrollment deleted")

remaining = session.query(Enrollment).count()

print("Remaining enrollments:", remaining)