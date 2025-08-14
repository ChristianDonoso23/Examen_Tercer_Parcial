<?php
declare(strict_types=1);
namespace App\Repositories;

use App\Interfaces\RepositoryInterface;
use App\Config\Database;
use App\Entities\Equipo;
use PDO;

class EquipoRepository implements RepositoryInterface
{
    private PDO $db;

    public function __construct()
    {
        $this->db = Database::getConnection();
    }

    public function findAll(): array
    {
        $stmt = $this->db->query("CALL sp_equipos_list()");
        $rows = $stmt->fetchAll();
        $stmt->closeCursor();
        $out = [];
        foreach ($rows as $r) {
            $out[] = $this->hydrateBasic($r);
        }
        return $out;
    }

    public function findById(int $id): ?object
    {
        return $this->findByIdString((string)$id);
    }

    public function findByIdString(string $id): ?object
    {
        $stmt = $this->db->prepare("CALL sp_find_equipo(:id)");
        $stmt->execute([':id' => $id]);
        $row = $stmt->fetch();
        $stmt->closeCursor();
        return $row ? $this->hydrateFull($row) : null;
    }

    public function create(object $entity): bool
    {
        if (!$entity instanceof Equipo) {
            throw new \InvalidArgumentException('Expected an instance of Equipo');
        }

        $stmt = $this->db->prepare("CALL sp_create_equipo(:id, :nombre, :hackathon_id)");
        
        $ok = $stmt->execute([
            ':id' => $entity->getId(),
            ':nombre' => $entity->getNombre(),
            ':hackathon_id' => $entity->getHackathonId()
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
        $stmt = $this->db->prepare("CALL sp_delete_equipo(:id)");
        $ok = $stmt->execute([':id' => $id]);
        if ($ok) {
            $stmt->fetch();
        }
        $stmt->closeCursor();
        return $ok;
    }

    public function addParticipante(string $equipoId, string $participanteId, string $rolEnEquipo = 'miembro'): bool
    {
        $stmt = $this->db->prepare("CALL sp_add_participante_equipo(:equipo_id, :participante_id, :rol_en_equipo)");
        $ok = $stmt->execute([
            ':equipo_id' => $equipoId,
            ':participante_id' => $participanteId,
            ':rol_en_equipo' => $rolEnEquipo
        ]);
        if ($ok) {
            $stmt->fetch();
        }
        $stmt->closeCursor();
        return $ok;
    }

    public function addReto(string $equipoId, string $retoId, string $estado = 'asignado', int $progreso = 0): bool
    {
        $stmt = $this->db->prepare("CALL sp_add_reto_equipo(:equipo_id, :reto_id, :estado, :progreso_porcentaje)");
        $ok = $stmt->execute([
            ':equipo_id' => $equipoId,
            ':reto_id' => $retoId,
            ':estado' => $estado,
            ':progreso_porcentaje' => $progreso
        ]);
        if ($ok) {
            $stmt->fetch();
        }
        $stmt->closeCursor();
        return $ok;
    }

    private function hydrateBasic(array $row): Equipo
    {
        $equipo = new Equipo(
            $row['nombre'],
            $row['hackathon_id']
        );
        
        $equipo->setId($row['id']);
        return $equipo;
    }

    private function hydrateFull(array $row): Equipo
    {
        $equipo = new Equipo(
            $row['nombre'],
            $row['hackathon_id']
        );
        
        $equipo->setId($row['id']);

        // Procesar participantes
        $participantes = [];
        if (!empty($row['participantes'])) {
            $participantesData = explode(';', $row['participantes']);
            foreach ($participantesData as $participanteStr) {
                if (!empty($participanteStr)) {
                    $parts = explode(':', $participanteStr, 2);
                    if (count($parts) === 2) {
                        $participantes[] = [
                            'id' => $parts[0],
                            'nombre' => $parts[1]
                        ];
                    }
                }
            }
        }
        $equipo->setParticipantes($participantes);

        // Procesar retos
        $retos = [];
        if (!empty($row['retos'])) {
            $retosData = explode(';', $row['retos']);
            foreach ($retosData as $retoStr) {
                if (!empty($retoStr)) {
                    $parts = explode(':', $retoStr, 2);
                    if (count($parts) === 2) {
                        $retos[] = [
                            'id' => $parts[0],
                            'titulo' => $parts[1]
                        ];
                    }
                }
            }
        }
        $equipo->setRetos($retos);

        return $equipo;
    }
}