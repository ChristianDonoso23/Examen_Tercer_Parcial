<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Entities\RetoSolucionable;
use App\Entities\RetoReal;
use App\Entities\RetoExperimental;
use App\Repositories\RetoRepository;

class RetoController
{
    private RetoRepository $retoRepository;

    public function __construct()
    {
        $this->retoRepository = new RetoRepository();
    }

    public function retoToArray(RetoSolucionable $reto): array
    {
        $base = [
            'id' => $reto->getId(),
            'titulo' => $reto->getTitulo(),
            'descripcion' => $reto->getDescripcion(),
            'complejidad' => $reto->getComplejidad(),
            'areasConocimiento' => $reto->getAreasConocimiento(),
            'tipo' => $reto->getTipo()
        ];

        if ($reto instanceof RetoReal) {
            $base['entidadColaboradora'] = $reto->getEntidadColaboradora();
        } elseif ($reto instanceof RetoExperimental) {
            $base['enfoquePedagogico'] = $reto->getEnfoquePedagogico();
        }

        return $base;
    }

    public function handle(): void
    {
        header('Content-Type: application/json');
        $method = $_SERVER['REQUEST_METHOD'];

        if ($method === 'GET') {
            if (isset($_GET['id'])) {
                $reto = $this->retoRepository->findByIdString($_GET['id']);
                echo json_encode($reto ? $this->retoToArray($reto) : null);
            } else {
                $list = array_map(
                    fn(RetoSolucionable $reto) => $this->retoToArray($reto),
                    $this->retoRepository->findAll()
                );
                echo json_encode($list);
            }
            return;
        }

        $payload = json_decode(file_get_contents('php://input'), true);

        if ($method === 'POST') {
            try {
                $reto = $this->createRetoFromPayload($payload);
                $success = $this->retoRepository->create($reto);
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
            echo json_encode(['success' => $this->retoRepository->deleteById($id)]);
            return;
        }

        http_response_code(405);
        echo json_encode(['error' => 'Método no permitido']);
    }

    private function createRetoFromPayload(array $payload): RetoSolucionable
    {
        $tipo = $payload['tipo'] ?? '';
        $id = $payload['id'] ?? uniqid();
        $titulo = $payload['titulo'] ?? '';
        $descripcion = $payload['descripcion'] ?? '';
        $complejidad = $payload['complejidad'] ?? 'facil';
        $areasConocimiento = $payload['areasConocimiento'] ?? [];

        if ($tipo === 'retoReal') {
            $reto = new RetoReal(
                $titulo,
                $descripcion,
                $complejidad,
                $areasConocimiento,
                $payload['entidadColaboradora'] ?? ''
            );
            $reto->setId($id);
            return $reto;
        } elseif ($tipo === 'retoExperimental') {
            $reto = new RetoExperimental(
                $titulo,
                $descripcion,
                $complejidad,
                $areasConocimiento,
                $payload['enfoquePedagogico'] ?? ''
            );
            $reto->setId($id);
            return $reto;
        }

        throw new \InvalidArgumentException('Tipo de reto no válido: ' . $tipo);
    }
}