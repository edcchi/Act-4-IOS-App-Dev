const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const db = mysql.createConnection({
  host: 'localhost',  // 'localhost' since the database is hosted on XAMPP
  user: 'root',       // Default MySQL user in XAMPP
  password: '',       // Default MySQL password for XAMPP (usually empty)
  database: 'todo_app' // Name of your database
});

db.connect((err) => {
  if (err) throw err;
  console.log('Connected to MySQL database');
});

// Get all tasks
app.get('/tasks', (req, res) => {
  db.query('SELECT * FROM tasks', (err, results) => {
    if (err) res.status(500).send(err);
    else res.json(results);
  });
});

// Add a task
app.post('/tasks', (req, res) => {
  const { title, description } = req.body;
  db.query('INSERT INTO tasks (title, description) VALUES (?, ?)', [title, description], (err, result) => {
    if (err) res.status(500).send(err);
    else res.json({ id: result.insertId, title, description, isComplete: false });
  });
});

// Update a task
app.put('/tasks/:id', (req, res) => {
  const { id } = req.params;
  const { title, description, isComplete } = req.body;
  db.query('UPDATE tasks SET title = ?, description = ?, isComplete = ? WHERE id = ?', 
           [title, description, isComplete, id], 
           (err) => {
             if (err) res.status(500).send(err);
             else res.sendStatus(200);
           });
});

// Delete a task
app.delete('/tasks/:id', (req, res) => {
  db.query('DELETE FROM tasks WHERE id = ?', [req.params.id], (err) => {
    if (err) res.status(500).send(err);
    else res.sendStatus(204);
  });
});

const PORT = 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
