<?php
declare(strict_types=1);
namespace App\Repositories;

use App\Interfaces\RepositoryInterface;
use App\Config\Database;
use App\Entities\Hackathon;
use PDO;

class HackathonRepository implements RepositoryInterface
{
    private PDO $db;

    public function __construct()
    {
        $this->db = Database::getConnection();
    }

    public function findAll(): array
    {
        $stmt = $this->db->query("CALL sp_hackathons_list()");
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
        return $this->findByIdString((string)$id);
    }

    public function findByIdString(string $id): ?object
    {
        $stmt = $this->db->prepare("CALL sp_find_hackathon(:id)");
        $stmt->execute([':id' => $id]);
        $row = $stmt->fetch();
        $stmt->closeCursor();
        return $row ? $this->hydrate($row) : null;
    }

    public function create(object $entity): bool
    {
        if (!$entity instanceof Hackathon) {
            throw new \InvalidArgumentException('Expected an instance of Hackathon');
        }

        $stmt = $this->db->prepare("CALL sp_create_hackathon(:id, :nombre, :descripcion, :fecha_inicio, :fecha_fin, :lugar, :estado)");
        
        $ok = $stmt->execute([
            ':id' => $entity->getId(),
            ':nombre' => $entity->getNombre(),
            ':descripcion' => $entity->getDescripcion(),
            ':fecha_inicio' => $entity->getFechaInicio(),
            ':fecha_fin' => $entity->getFechaFin(),
            ':lugar' => $entity->getLugar(),
            ':estado' => $entity->getEstado()
        ]);
        
        if ($ok) {
            $stmt->fetch();
        }
        $stmt->closeCursor();
        return $ok;
    }

    public function update(object $entity): bool
    {
        if (!$entity instanceof Hackathon) {
            throw new \InvalidArgumentException('Expected an instance of Hackathon');
        }

        $stmt = $this->db->prepare("CALL sp_update_hackathon(:id, :nombre, :descripcion, :fecha_inicio, :fecha_fin, :lugar, :estado)");
        
        $ok = $stmt->execute([
            ':id' => $entity->getId(),
            ':nombre' => $entity->getNombre(),
            ':descripcion' => $entity->getDescripcion(),
            ':fecha_inicio' => $entity->getFechaInicio(),
            ':fecha_fin' => $entity->getFechaFin(),
            ':lugar' => $entity->getLugar(),
            ':estado' => $entity->getEstado()
        ]);
        
        if ($ok) {
            $stmt->fetch();
        }
        $stmt->closeCursor();
        return $ok;
    }

    public function delete(int $id): bool
    {
        return $this->deleteById((string)$id);
    }

    public function deleteById(string $id): bool
    {
        $stmt = $this->db->prepare("CALL sp_delete_hackathon(:id)");
        $ok = $stmt->execute([':id' => $id]);
        if ($ok) {
            $stmt->fetch();
        }
        $stmt->closeCursor();
        return $ok;
    }

    private function hydrate(array $row): Hackathon
    {
        $hackathon = new Hackathon(
            $row['nombre'],
            $row['descripcion'],
            $row['fecha_inicio'],
            $row['fecha_fin'],
            $row['lugar'],
            $row['estado']
        );
        
        $hackathon->setId($row['id']);
        return $hackathon;
    }
}