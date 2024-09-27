-- CREATING THE TABLES

-- 1. 'users' TABLE (no foreign keys)
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name CHAR(50) NOT NULL,
    surname CHAR(50) NOT NULL,
    email CHAR(50) NOT NULL UNIQUE,
    phone CHAR(50) NOT NULL,
    nif CHAR(50) NOT NULL,
    location CHAR(100) NOT NULL,
    age INT NOT NULL
);

-- 2. 'bootcamp' TABLE (no foreign keys)
CREATE TABLE bootcamp (
    bootcamp_id SERIAL PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    bootcamp_name CHAR(100) NOT NULL,
    price FLOAT NOT NULL,
    suscription_state CHAR(20) NOT NULL
);

-- 3. 'professors' TABLE (references 'bootcamp')
CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    name CHAR(50) NOT NULL,
    surname CHAR(50) NOT NULL,
    email CHAR(50) NOT NULL UNIQUE,
    phone CHAR(50) NOT NULL,
    nif CHAR(50) NOT NULL,
    location CHAR(100) NOT NULL,
    age INT NOT NULL,
    bootcamp_id INT NOT NULL,
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamp (bootcamp_id)
);

-- 4. 'modules' TABLE (references 'professors', 'bootcamp')
CREATE TABLE modules (
    module_id SERIAL PRIMARY KEY,
    module_name CHAR(100) NOT NULL,
    professor_id INT NOT NULL,
    bootcamp_id INT NOT NULL,
    FOREIGN KEY (professor_id) REFERENCES professors (professor_id),
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamp (bootcamp_id)
);

-- 5. 'professor_modules' TABLE (junction table for many-to-many relationship)
CREATE TABLE professor_modules (
    professor_id INT NOT NULL,
    module_id INT NOT NULL,
    PRIMARY KEY (professor_id, module_id),
    FOREIGN KEY (professor_id) REFERENCES professors (professor_id),
    FOREIGN KEY (module_id) REFERENCES modules (module_id)
);

-- 6. 'enrollments' TABLE (junction table for many-to-many relationship)
CREATE TABLE enrollments (
    bootcamp_id INT NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY (bootcamp_id, user_id),
    FOREIGN KEY (bootcamp_id) REFERENCES bootcamp (bootcamp_id),
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

-- 7. 'invoice' TABLE (references 'users')
CREATE TABLE invoice (
    user_id INT NOT NULL,
    billing_id SERIAL PRIMARY KEY,
    price FLOAT NOT NULL,
    payment_method CHAR(50) NOT NULL,
    scholarship CHAR(50) NOT NULL,
    suscription_state CHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

-- INSERTING DATA

-- 1. Insert values into 'users' TABLE
INSERT INTO users (name, surname, email, phone, nif, location, age)
VALUES
('Karen', 'Blanco', 'kb@correo.com', '123456789', 'NIF123', 'Barcelona', 36),
('Diana', 'Gomez', 'dg@correo.com', '987654321', 'NIF456', 'Porto', 28),
('Jorge', 'Torres', 'jt@correo.com', '123987456', 'NIF678', 'Madrid', 32),
('Fernando', 'Molina', 'fm@correo.com', '321654987', 'NIF789', 'Bogota', 25);

-- 2. Insert values into 'bootcamp' TABLE
INSERT INTO bootcamp (start_date, end_date, bootcamp_name, price, suscription_state)
VALUES
('2023-01-10', '2023-03-20', 'AI Fullstack Bootcamp', 7500.00, 'active'),
('2023-04-01', '2023-06-15', 'Data Science Bootcamp', 6000.00, 'active'),
('2023-07-05', '2023-09-10', 'Blockchain Bootcamp', 7000.00, 'active'),
('2023-10-01', '2023-12-31', 'Ciberseguridad Bootcamp', 6800.00, 'pending');

-- 3. Insert values into 'professors' TABLE (after 'bootcamp' is populated)
INSERT INTO professors (name, surname, email, phone, nif, location, age, bootcamp_id)
VALUES
('Emilia', 'Rodriguez', 'er@bootcamp.com', '456123789', 'PROF001', 'Malaga', 38, 1),
('Carlos', 'Rengijo', 'cr@bootcamp.com', '32198765', 'PROF002', 'Miami', 45, 2),
('Sara', 'Rojas', 'sr@bootcamp.com', '789123456', 'PROF003', 'Toledo', 37, 3),
('Ramon', 'Cruz', 'rc@bootcamp.com', '654789321', 'PROF004', 'Zaragoza', 47, 4);

-- 4. Insert values into 'modules' TABLE (after 'professors' and 'bootcamp' are populated)
INSERT INTO modules (module_name, professor_id, bootcamp_id)
VALUES
('AI Fullstack 101', 1, 1),
('Data Science 101', 2, 2),
('Blockchain 101', 3, 3),
('Ciberseguridad 101', 4, 4);

-- 5. Insert values into 'professor_modules' TABLE (after 'professors' and 'modules' are populated)
INSERT INTO professor_modules (professor_id, module_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- 6. Insert values into 'enrollments' TABLE (after 'users' and 'bootcamp' are populated)
INSERT INTO enrollments (bootcamp_id, user_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- 7. Insert values into 'invoice' TABLE (after 'users' are populated)
INSERT INTO invoice (user_id, price, payment_method, scholarship, suscription_state)
VALUES
(1, 7500.00, 'Credit Card', 'No', 'active'),
(2, 6000.00, 'Bank Transfer', 'Yes', 'active'),
(3, 7000.00, 'Paypal', 'No', 'active'),
(4, 6800.00, 'Credit Card', 'Yes', 'pending');
