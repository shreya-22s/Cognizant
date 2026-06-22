import psycopg2
import time

conn = psycopg2.connect(
    database="college_db",
    user="postgres",
    password="Rit05Sy$l",
    host="localhost",
    port="5432"
)

cur = conn.cursor()

start = time.time()

cur.execute("""
SELECT
    e.student_id,
    c.course_name,
    s.first_name,
    s.last_name
FROM enrollments e
JOIN students s
ON e.student_id = s.student_id
JOIN courses c
ON e.course_id = c.course_id
""")

rows = cur.fetchall()

end = time.time()

print("Queries executed: 1")
print("Time:", end-start)



#for task 56 output is:
#Queries executed: 14
#Time: 0.004954814910888672

#for task 57 output isL
#Queries executed: 1
#Time: 0.004687070846557617