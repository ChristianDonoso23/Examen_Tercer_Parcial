<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Entities\Equipo;
use App\Repositories\EquipoRepository;

class EquipoController
{
    private EquipoRepository $equipoRepository;

    public function __construct()
    {
        $this->equipoRepository = new EquipoRepository();
    }

    public function equipoToArray(Equipo $equipo): array
    {
        return [
            'id' => $equipo->getId(),
            'nombre' => $equipo->getNombre(),
            'hackathonId' => $equipo->getHackathonId(),
            'participantes' => $equipo->getParticipantes(),
            'retos' => $equipo->getRetos()
        ];
    }

    public function handle(): void
    {
        header('Content-Type: application/json');
        $method = $_SERVER['REQUEST_METHOD'];
        $uri = $_SERVER['REQUEST_URI'];

        if ($method === 'GET') {
            if (isset($_GET['id'])) {
                $equipo = $this->equipoRepository->findByIdString($_GET['id']);
                echo json_encode($equipo ? $this->equipoToArray($equipo) : null);
            } else {
                $list = array_map(
                    fn(Equipo $equipo) => $this->equipoToArray($equipo),
                    $this->equipoRepository->findAll()
                );
                echo json_encode($list);
            }
            return;
        }

        $payload = json_decode(file_get_contents('php://input'), true);

        if ($method === 'POST') {
            // Verificar si es una operación especial (agregar participante o reto)
            if (isset($payload['action'])) {
                $this->handleSpecialAction($payload);
                return;
            }

            try {
                $equipo = $this->createEquipoFromPayload($payload);
                $success = $this->equipoRepository->create($equipo);
                echo json_encode(['success' => $success]);
            } catch (\Exception $e) {
                http_response_code(400);
                echo json_encode(['error' => $e->getMessage()]);
            }
            return;
        }

        if ($method === 'DELETE') {
            $id = $payload['id'] ?? '';
            if (empty($id)) {
                http_response_code(400);
                echo json_encode(['error' => 'ID requerido']);
                return;
            }
            echo json_encode(['success' => $this->equipoRepository->deleteById($id)]);
            return;
        }

        http_response_code(405);
        echo json_encode(['error' => 'Método no permitido']);
    }

    private function handleSpecialAction(array $payload): void
    {
        $action = $payload['action'];
        
        if ($action === 'addParticipante') {
            $equipoId = $payload['equipoId'] ?? '';
            $participanteId = $payload['participanteId'] ?? '';
            $rolEnEquipo = $payload['rolEnEquipo'] ?? 'miembro';

            if (empty($equipoId) || empty($participanteId)) {
                http_response_code(400);
                echo json_encode(['error' => 'equipoId y participanteId son requeridos']);
                return;
            }

            $success = $this->equipoRepository->addParticipante($equipoId, $participanteId, $rolEnEquipo);
            echo json_encode(['success' => $success]);
            return;
        }

        if ($action === 'addReto') {
            $equipoId = $payload['equipoId'] ?? '';
            $retoId = $payload['retoId'] ?? '';
            $estado = $payload['estado'] ?? 'asignado';
            $progreso = (int)($payload['progreso'] ?? 0);

            if (empty($equipoId) || empty($retoId)) {
                http_response_code(400);
                echo json_encode(['error' => 'equipoId y retoId son requeridos']);
                return;
            }

            $success = $this->equipoRepository->addReto($equipoId, $retoId, $estado, $progreso);
            echo json_encode(['success' => $success]);
            return;
        }

        http_response_code(400);
        echo json_encode(['error' => 'Acción no válida']);
    }

    private function createEquipoFromPayload(array $payload): Equipo
    {
        $id = $payload['id'] ?? uniqid();
        $nombre = $payload['nombre'] ?? '';
        $hackathonId = $payload['hackathonId'] ?? '';
        $participantes = $payload['participantes'] ?? [];

        if (empty($nombre) || empty($hackathonId)) {
            throw new \InvalidArgumentException('Nombre y hackathonId son requeridos');
        }

        $equipo = new Equipo($nombre, $hackathonId, $participantes);
        $equipo->setId($id);
        
        return $equipo;
    }
}