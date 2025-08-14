<?php

declare(strict_types=1);

namespace App\Repositories;

use App\Interfaces\RepositoryInterface;
use App\Config\Database;
use App\Entities\RetoSolucionable;
use App\Entities\RetoReal;
use App\Entities\RetoExperimental;
use PDO;

class RetoRepository implements RepositoryInterface
{
    private PDO $db;

    public function __construct()
    {
        $this->db = Database::getConnection();
    }

    public function findAll(): array
    {
        $stmt = $this->db->query("CALL sp_retos_list()");
        $rows = $stmt->fetchAll();
        $stmt->closeCursor();
        $out = [];
        foreach ($rows as $r) {
            $out[] = $this->hydrate($r);
        }
        return $out;
    }

    public function findById(int $id): ?object
    {
        $stmt = $this->db->prepare("CALL sp_find_reto(:id)");
        $stmt->execute([':id' => (string)$id]);
        $row = $stmt->fetch();
        $stmt->closeCursor();
        return $row ? $this->hydrate($row) : null;
    }

    public function findByIdString(string $id): ?object
    {
        $stmt = $this->db->prepare("CALL sp_find_reto(:id)");
        $stmt->execute([':id' => $id]);
        $row = $stmt->fetch();
        $stmt->closeCursor();
        return $row ? $this->hydrate($row) : null;
    }

    public function create(object $entity): bool
    {
        if ($entity instanceof RetoReal) {
            return $this->createRetoReal($entity);
        } elseif ($entity instanceof RetoExperimental) {
            return $this->createRetoExperimental($entity);
        }
        throw new \InvalidArgumentException('Tipo de reto no soportado');
    }

    private function createRetoReal(RetoReal $reto): bool
    {
        $stmt = $this->db->prepare("CALL sp_create_reto_real(:id, :titulo, :descripcion, :complejidad, :entidad_colaboradora, :areas_conocimiento)");
        $areasJson = json_encode($reto->getAreasConocimiento());

        $ok = $stmt->execute([
            ':id' => $reto->getId(),
            ':titulo' => $reto->getTitulo(),
            ':descripcion' => $reto->getDescripcion(),
            ':complejidad' => $reto->getComplejidad(),
            ':entidad_colaboradora' => $reto->getEntidadColaboradora(),
            ':areas_conocimiento' => $areasJson
        ]);

        if ($ok) {
            $stmt->fetch();
        }
        $stmt->closeCursor();
        return $ok;
    }

    private function createRetoExperimental(RetoExperimental $reto): bool
    {
        $stmt = $this->db->prepare("CALL sp_create_reto_experimental(:id, :titulo, :descripcion, :complejidad, :enfoque_pedagogico, :areas_conocimiento)");
        $areasJson = json_encode($reto->getAreasConocimiento());

        $ok = $stmt->execute([
            ':id' => $reto->getId(),
            ':titulo' => $reto->getTitulo(),
            ':descripcion' => $reto->getDescripcion(),
            ':complejidad' => $reto->getComplejidad(),
            ':enfoque_pedagogico' => $reto->getEnfoquePedagogico(),
            ':areas_conocimiento' => $areasJson
        ]);

        if ($ok) {
            $stmt->fetch();
        }
        $stmt->closeCursor();
        return $ok;
    }

    public function update(object $entity): bool
    {
        // Los procedimientos de actualización no están implementados en el SQL
        throw new \Exception('Método update no implementado en los procedimientos almacenados');
    }

    public function delete(int $id): bool
    {
        return $this->deleteById((string)$id);
    }

    public function deleteById(string $id): bool
    {
        $stmt = $this->db->prepare("CALL sp_delete_reto(:id)");
        $ok = $stmt->execute([':id' => $id]);
        if ($ok) {
            $stmt->fetch();
        }
        $stmt->closeCursor();
        return $ok;
    }

    private function hydrate(array $row): RetoSolucionable
    {
        $areasConocimiento = !empty($row['areas_conocimiento']) ? explode(',', $row['areas_conocimiento']) : [];

        if ($row['tipo'] === 'retoReal') {
            $reto = new RetoReal(
                $row['titulo'],
                $row['descripcion'],
                $row['complejidad'],
                $areasConocimiento,
                $row['entidad_colaboradora'] ?? ''
            );
            $reto->setId($row['id']);
            return $reto;
        } elseif ($row['tipo'] === 'retoExperimental') {
            $reto = new RetoExperimental(
                $row['titulo'],
                $row['descripcion'],
                $row['complejidad'],
                $areasConocimiento,
                $row['enfoque_pedagogico'] ?? ''
            );
            $reto->setId($row['id']);
            return $reto;
        }

        throw new \Exception('Tipo de reto desconocido: ' . $row['tipo']);
    }
}
