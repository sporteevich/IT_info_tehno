-- Практическая работа №8. Анализ данных с помощью SQL-запросов
-- Студент: Алёшкин Константин ИСП 211
-- База данных: aleshkin_bd (КОЛЛЕДЖ)

USE aleshkin_bd;

-- 1. Список всех студентов с названиями их групп
SELECT s.last_name, s.first_name, g.group_name
FROM students s
LEFT JOIN groups g ON s.group_id = g.group_id
ORDER BY s.last_name;

-- 2. Количество студентов в каждой группе
SELECT g.group_name, COUNT(s.student_id) AS cnt
FROM groups g
LEFT JOIN students s ON g.group_id = s.group_id
GROUP BY g.group_name;

-- 3. Расписание занятий с полной информацией
SELECT l.lesson_date, g.group_name, d.discipline_name, t.last_name AS teacher
FROM lessons l
JOIN groups g      ON l.group_id = g.group_id
JOIN disciplines d ON l.discipline_id = d.discipline_id
JOIN teachers t    ON l.teacher_id = t.teacher_id;

-- 4. Нагрузка преподавателей (количество занятий)
SELECT t.last_name, COUNT(l.lesson_id) AS cnt
FROM teachers t
LEFT JOIN lessons l ON t.teacher_id = l.teacher_id
GROUP BY t.last_name
ORDER BY cnt DESC;

-- 5. Студенты, родившиеся после 2007 года
SELECT last_name, first_name, birth_date
FROM students
WHERE birth_date > '2007-01-01';

-- 6. Дисциплины с количеством часов больше 72
SELECT discipline_name, hours
FROM disciplines
WHERE hours > 72;

-- 7. Группы, в которых больше одного студента
SELECT g.group_name, COUNT(*) AS cnt
FROM groups g
JOIN students s ON g.group_id = s.group_id
GROUP BY g.group_name
HAVING COUNT(*) > 1;

-- 8. Средняя нагрузка на преподавателя (подзапрос)
SELECT AVG(lc) AS avg_load
FROM (SELECT COUNT(*) AS lc FROM lessons GROUP BY teacher_id) t;

-- 9. Список групп и специальностей (без дубликатов)
SELECT DISTINCT group_name, specialty FROM groups;

-- 10. Студенты и их группы (через подзапрос)
SELECT last_name, first_name,
  (SELECT group_name FROM groups g WHERE g.group_id = s.group_id) AS group_name
FROM students s;

-- 11. Транзакция с откатом (TCL)
BEGIN;
UPDATE students SET group_id = 2 WHERE student_id = 1;
ROLLBACK;

-- 12. Представление (VIEW)
CREATE OR REPLACE VIEW v_students_groups AS
SELECT s.last_name, g.group_name
FROM students s JOIN groups g ON s.group_id = g.group_id;

-- 13. Индекс для ускорения выборки по дате занятия
CREATE INDEX idx_lesson_date ON lessons(lesson_date);

-- 14. Анализ оценок: средний балл по студентам
SELECT s.last_name, AVG(g.grade) AS avg_grade
FROM grades g
JOIN students s ON g.student_id = s.student_id
GROUP BY s.last_name
ORDER BY avg_grade DESC;

-- 15. Лучшие студенты (средний балл > 4.5)
SELECT s.last_name, AVG(g.grade) AS avg_grade
FROM grades g
JOIN students s ON g.student_id = s.student_id
GROUP BY s.last_name
HAVING AVG(g.grade) > 4.5;