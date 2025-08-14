<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Entities\Hackathon;
use App\Repositories\HackathonRepository;

class HackathonController
{
    private HackathonRepository $hackathonRepository;

    public function __construct()
    {
        $this->hackathonRepository = new HackathonRepository();
    }

    public function hackathonToArray(Hackathon $hackathon): array
    {
        return [
            'id' => $hackathon->getId(),
            'nombre' => $hackathon->getNombre(),
            'descripcion' => $hackathon->getDescripcion(),
            'fechaInicio' => $hackathon->getFechaInicio(),
            'fechaFin' => $hackathon->getFechaFin(),
            'lugar' => $hackathon->getLugar(),
            'estado' => $hackathon->getEstado()
        ];
    }

    public function handle(): void
    {
        header('Content-Type: application/json');
        $method = $_SERVER['REQUEST_METHOD'];

        if ($method === 'GET') {
            if (isset($_GET['id'])) {
                $hackathon = $this->hackathonRepository->findByIdString($_GET['id']);
                echo json_encode($hackathon ? $this->hackathonToArray($hackathon) : null);
            } else {
                $list = array_map(
                    fn(Hackathon $hackathon) => $this->hackathonToArray($hackathon),
                    $this->hackathonRepository->findAll()
                );
                echo json_encode($list);
            }
            return;
        }

        $payload = json_decode(file_get_contents('php://input'), true);

        if ($method === 'POST') {
            try {
                $hackathon = $this->createHackathonFromPayload($payload);
                $success = $this->hackathonRepository->create($hackathon);
                echo json_encode(['success' => $success]);
            } catch (\Exception $e) {
                http_response_code(400);
                echo json_encode(['error' => $e->getMessage()]);
            }
            return;
        }

        if ($method === 'PUT') {
            $id = $payload['id'] ?? '';
            if (empty($id)) {
                http_response_code(400);
                echo json_encode(['error' => 'ID requerido']);
                return;
            }

            $existing = $this->hackathonRepository->findByIdString($id);
            if (!$existing) {
                http_response_code(404);
                echo json_encode(['error' => 'Hackathon no encontrado']);
                return;
            }

            // Actualizar campos si están presentes
            if (isset($payload['nombre'])) $existing->setNombre($payload['nombre']);
            if (isset($payload['descripcion'])) $existing->setDescripcion($payload['descripcion']);
            if (isset($payload['fechaInicio'])) $existing->setFechaInicio($payload['fechaInicio']);
            if (isset($payload['fechaFin'])) $existing->setFechaFin($payload['fechaFin']);
            if (isset($payload['lugar'])) $existing->setLugar($payload['lugar']);
            if (isset($payload['estado'])) $existing->setEstado($payload['estado']);

            echo json_encode(['success' => $this->hackathonRepository->update($existing)]);
            return;
        }

        if ($method === 'DELETE') {
            $id = $payload['id'] ?? '';
            if (empty($id)) {
                http_response_code(400);
                echo json_encode(['error' => 'ID requerido']);
                return;
            }
            echo json_encode(['success' => $this->hackathonRepository->deleteById($id)]);
            return;
        }

        http_response_code(405);
        echo json_encode(['error' => 'Método no permitido']);
    }

    private function createHackathonFromPayload(array $payload): Hackathon
    {
        $id = $payload['id'] ?? uniqid();
        $nombre = $payload['nombre'] ?? '';
        $descripcion = $payload['descripcion'] ?? '';
        $fechaInicio = $payload['fechaInicio'] ?? date('Y-m-d');
        $fechaFin = $payload['fechaFin'] ?? date('Y-m-d');
        $lugar = $payload['lugar'] ?? '';
        $estado = $payload['estado'] ?? 'planificado';

        $hackathon = new Hackathon(
            $nombre,
            $descripcion,
            $fechaInicio,
            $fechaFin,
            $lugar,
            $estado
        );
        
        $hackathon->setId($id);
        return $hackathon;
    }
}