<?php
// Script para poblar la base de datos con datos de prueba
require_once __DIR__ . '/Config/Database.php';

use App\Config\Database;

$pdo = Database::getConnection();

try {
    // Insertar 10 participantes (5 estudiantes, 5 mentores)
    $participantes = [
        // Estudiantes
        ['id' => 'est1', 'tipo' => 'estudiante', 'nombre' => 'Ana Torres', 'email' => 'ana1@correo.com', 'nivel_habilidad' => 'basico'],
        ['id' => 'est2', 'tipo' => 'estudiante', 'nombre' => 'Luis Pérez', 'email' => 'luis2@correo.com', 'nivel_habilidad' => 'intermedio'],
        ['id' => 'est3', 'tipo' => 'estudiante', 'nombre' => 'María López', 'email' => 'maria3@correo.com', 'nivel_habilidad' => 'avanzado'],
        ['id' => 'est4', 'tipo' => 'estudiante', 'nombre' => 'Carlos Ruiz', 'email' => 'carlos4@correo.com', 'nivel_habilidad' => 'intermedio'],
        ['id' => 'est5', 'tipo' => 'estudiante', 'nombre' => 'Sofía Díaz', 'email' => 'sofia5@correo.com', 'nivel_habilidad' => 'basico'],
        // Mentores
        ['id' => 'men1', 'tipo' => 'mentorTecnico', 'nombre' => 'Pedro Gómez', 'email' => 'pedro1@correo.com', 'nivel_habilidad' => 'avanzado'],
        ['id' => 'men2', 'tipo' => 'mentorTecnico', 'nombre' => 'Lucía Fernández', 'email' => 'lucia2@correo.com', 'nivel_habilidad' => 'intermedio'],
        ['id' => 'men3', 'tipo' => 'mentorTecnico', 'nombre' => 'Javier Castro', 'email' => 'javier3@correo.com', 'nivel_habilidad' => 'basico'],
        ['id' => 'men4', 'tipo' => 'mentorTecnico', 'nombre' => 'Marta Salas', 'email' => 'marta4@correo.com', 'nivel_habilidad' => 'intermedio'],
        ['id' => 'men5', 'tipo' => 'mentorTecnico', 'nombre' => 'Diego Rivas', 'email' => 'diego5@correo.com', 'nivel_habilidad' => 'avanzado'],
    ];
    foreach ($participantes as $p) {
        $pdo->prepare("INSERT INTO participantes (id, tipo, nombre, email, nivel_habilidad) VALUES (?, ?, ?, ?, ?)")
            ->execute([$p['id'], $p['tipo'], $p['nombre'], $p['email'], $p['nivel_habilidad']]);
    }

    // Insertar 2 hackathons
    $hackathons = [
        ['id' => 'hack1', 'nombre' => 'Hackathon Escolar', 'descripcion' => 'Evento para estudiantes', 'fecha_inicio' => '2025-08-20', 'fecha_fin' => '2025-08-22', 'lugar' => 'Colegio Central', 'estado' => 'planificado'],
        ['id' => 'hack2', 'nombre' => 'Hackathon IA', 'descripcion' => 'Desafíos de inteligencia artificial', 'fecha_inicio' => '2025-09-10', 'fecha_fin' => '2025-09-12', 'lugar' => 'Universidad Técnica', 'estado' => 'activo'],
    ];
    foreach ($hackathons as $h) {
        $pdo->prepare("INSERT INTO hackathons (id, nombre, descripcion, fecha_inicio, fecha_fin, lugar, estado) VALUES (?, ?, ?, ?, ?, ?, ?)")
            ->execute([$h['id'], $h['nombre'], $h['descripcion'], $h['fecha_inicio'], $h['fecha_fin'], $h['lugar'], $h['estado']]);
    }

    // Insertar 3 retos
    $retos = [
        ['id' => 'reto1', 'tipo' => 'retoReal', 'titulo' => 'App de Reciclaje', 'descripcion' => 'Crear una app para fomentar el reciclaje.', 'complejidad' => 'media'],
        ['id' => 'reto2', 'tipo' => 'retoExperimental', 'titulo' => 'Simulación Solar', 'descripcion' => 'Simular el uso de energía solar en escuelas.', 'complejidad' => 'dificil'],
        ['id' => 'reto3', 'tipo' => 'retoReal', 'titulo' => 'Plataforma de Tutorías', 'descripcion' => 'Desarrollar una plataforma para tutorías online.', 'complejidad' => 'facil'],
    ];
    foreach ($retos as $r) {
        $pdo->prepare("INSERT INTO retos (id, tipo, titulo, descripcion, complejidad) VALUES (?, ?, ?, ?, ?)")
            ->execute([$r['id'], $r['tipo'], $r['titulo'], $r['descripcion'], $r['complejidad']]);
    }

    // Insertar 2 equipos
    $equipos = [
        ['id' => 'eq1', 'nombre' => 'Equipo Alfa', 'hackathon_id' => 'hack1'],
        ['id' => 'eq2', 'nombre' => 'Equipo Beta', 'hackathon_id' => 'hack2'],
    ];
    foreach ($equipos as $e) {
        $pdo->prepare("INSERT INTO equipos (id, nombre, hackathon_id) VALUES (?, ?, ?)")
            ->execute([$e['id'], $e['nombre'], $e['hackathon_id']]);
    }

    echo "Datos de prueba insertados correctamente.\n";
} catch (Exception $ex) {
    echo "Error: " . $ex->getMessage() . "\n";
}
