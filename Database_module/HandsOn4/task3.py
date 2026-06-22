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

query_count = 0

start = time.time()

cur.execute("SELECT * FROM enrollments")
enrollments = cur.fetchall()

query_count += 1

for e in enrollments:
    student_id = e[0]

    cur.execute(
        """
        SELECT first_name,last_name
        FROM students
        WHERE student_id=%s
        """,
        (student_id,)
    )

    cur.fetchone()

    query_count += 1

end = time.time()

print("Queries executed:", query_count)
print("Time:", end-start)