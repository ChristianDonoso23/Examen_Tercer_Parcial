<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Entities\Participante;
use App\Entities\Estudiante;
use App\Entities\MentorTecnico;
use App\Repositories\ParticipanteRepository;

class ParticipanteController
{
    private ParticipanteRepository $participanteRepository;

    public function __construct()
    {
        $this->participanteRepository = new ParticipanteRepository();
    }

    public function participanteToArray(Participante $participante): array
    {
        $base = [
            'id' => $participante->getId(),
            'nombre' => $participante->getNombre(),
            'email' => $participante->getEmail(),
            'nivelHabilidad' => $participante->getNivelHabilidad(),
            'habilidades' => $participante->getHabilidades(),
            'tipo' => $participante->getTipo()
        ];

        if ($participante instanceof Estudiante) {
            $base['grado'] = $participante->getGrado();
            $base['institucion'] = $participante->getInstitucion();
            $base['tiempoDisponibleSemanal'] = $participante->getTiempoDisponibleSemanal();
        } elseif ($participante instanceof MentorTecnico) {
            $base['especialidad'] = $participante->getEspecialidad();
            $base['experiencia'] = $participante->getExperiencia();
            $base['disponibilidadHoraria'] = $participante->getDisponibilidadHoraria();
        }

        return $base;
    }

    public function handle(): void
    {
        header('Content-Type: application/json');
        $method = $_SERVER['REQUEST_METHOD'];

        if ($method === 'GET') {
            if (isset($_GET['id'])) {
                $participante = $this->participanteRepository->findByIdString($_GET['id']);
                echo json_encode($participante ? $this->participanteToArray($participante) : null);
            } else {
                $list = array_map(
                    fn(Participante $participante) => $this->participanteToArray($participante),
                    $this->participanteRepository->findAll()
                );
                echo json_encode($list);
            }
            return;
        }

        $payload = json_decode(file_get_contents('php://input'), true);

        if ($method === 'POST') {
            try {
                $participante = $this->createParticipanteFromPayload($payload);
                $success = $this->participanteRepository->create($participante);
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
            echo json_encode(['success' => $this->participanteRepository->deleteById($id)]);
            return;
        }

        http_response_code(405);
        echo json_encode(['error' => 'Método no permitido']);
    }

    private function createParticipanteFromPayload(array $payload): Participante
    {
        $tipo = $payload['tipo'] ?? '';
        $id = $payload['id'] ?? '';
        $nombre = $payload['nombre'] ?? '';
        $email = $payload['email'] ?? '';
        $nivelHabilidad = $payload['nivelHabilidad'] ?? 'basico';
        $habilidades = $payload['habilidades'] ?? [];

        if ($tipo === 'estudiante') {
            return new Estudiante(
                $id,
                $nombre,
                $email,
                $nivelHabilidad,
                $habilidades,
                $payload['grado'] ?? '',
                $payload['institucion'] ?? '',
                (int)($payload['tiempoDisponibleSemanal'] ?? 0)
            );
        } elseif ($tipo === 'mentorTecnico') {
            return new MentorTecnico(
                $id,
                $nombre,
                $email,
                $nivelHabilidad,
                $habilidades,
                $payload['especialidad'] ?? '',
                (int)($payload['experiencia'] ?? 0),
                $payload['disponibilidadHoraria'] ?? ''
            );
        }

        throw new \InvalidArgumentException('Tipo de participante no válido: ' . $tipo);
    }
}