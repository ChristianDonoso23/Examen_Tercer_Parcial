<?php
declare(strict_types=1);
namespace App\Repositories;

use App\Interfaces\RepositoryInterface;
use App\Config\Database;
use App\Entities\Participante;
use App\Entities\Estudiante;
use App\Entities\MentorTecnico;
use PDO;

class ParticipanteRepository implements RepositoryInterface
{
    private PDO $db;

    public function __construct()
    {
        $this->db = Database::getConnection();
    }

    public function findAll(): array
    {
        $stmt = $this->db->query("CALL sp_participantes_list()");
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
        $stmt = $this->db->prepare("CALL sp_find_participante(:id)");
        $stmt->execute([':id' => (string)$id]);
        $row = $stmt->fetch();
        $stmt->closeCursor();
        return $row ? $this->hydrate($row) : null;
    }

    public function findByIdString(string $id): ?object
    {
        $stmt = $this->db->prepare("CALL sp_find_participante(:id)");
        $stmt->execute([':id' => $id]);
        $row = $stmt->fetch();
        $stmt->closeCursor();
        return $row ? $this->hydrate($row) : null;
    }

    public function create(object $entity): bool
    {
        if ($entity instanceof Estudiante) {
            return $this->createEstudiante($entity);
        } elseif ($entity instanceof MentorTecnico) {
            return $this->createMentorTecnico($entity);
        }
        throw new \InvalidArgumentException('Tipo de participante no soportado');
    }

    private function createEstudiante(Estudiante $estudiante): bool
    {
        $stmt = $this->db->prepare("CALL sp_create_estudiante(:id, :nombre, :email, :nivel_habilidad, :grado, :institucion, :tiempo_disponible_semanal, :habilidades)");
        $habilidadesJson = json_encode($estudiante->getHabilidades());
        
        $ok = $stmt->execute([
            ':id' => $estudiante->getId(),
            ':nombre' => $estudiante->getNombre(),
            ':email' => $estudiante->getEmail(),
            ':nivel_habilidad' => $estudiante->getNivelHabilidad(),
            ':grado' => $estudiante->getGrado(),
            ':institucion' => $estudiante->getInstitucion(),
            ':tiempo_disponible_semanal' => $estudiante->getTiempoDisponibleSemanal(),
            ':habilidades' => $habilidadesJson
        ]);
        
        if ($ok) {
            $stmt->fetch();
        }
        $stmt->closeCursor();
        return $ok;
    }

    private function createMentorTecnico(MentorTecnico $mentor): bool
    {
        $stmt = $this->db->prepare("CALL sp_create_mentor_tecnico(:id, :nombre, :email, :nivel_habilidad, :especialidad, :experiencia, :disponibilidad_horaria, :habilidades)");
        $habilidadesJson = json_encode($mentor->getHabilidades());
        
        $ok = $stmt->execute([
            ':id' => $mentor->getId(),
            ':nombre' => $mentor->getNombre(),
            ':email' => $mentor->getEmail(),
            ':nivel_habilidad' => $mentor->getNivelHabilidad(),
            ':especialidad' => $mentor->getEspecialidad(),
            ':experiencia' => $mentor->getExperiencia(),
            ':disponibilidad_horaria' => $mentor->getDisponibilidadHoraria(),
            ':habilidades' => $habilidadesJson
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
        // Se requiere implementar sp_update_estudiante y sp_update_mentor_tecnico
        throw new \Exception('Método update no implementado en los procedimientos almacenados');
    }

    public function delete(int $id): bool
    {
        return $this->deleteById((string)$id);
    }

    public function deleteById(string $id): bool
    {
        $stmt = $this->db->prepare("CALL sp_delete_participante(:id)");
        $ok = $stmt->execute([':id' => $id]);
        if ($ok) {
            $stmt->fetch();
        }
        $stmt->closeCursor();
        return $ok;
    }

    private function hydrate(array $row): Participante
    {
        $habilidades = !empty($row['habilidades']) ? explode(',', $row['habilidades']) : [];
        
        if ($row['tipo'] === 'estudiante') {
            return new Estudiante(
                $row['id'],
                $row['nombre'],
                $row['email'],
                $row['nivel_habilidad'],
                $habilidades,
                $row['grado'] ?? '',
                $row['institucion'] ?? '',
                (int)($row['tiempo_disponible_semanal'] ?? 0)
            );
        } elseif ($row['tipo'] === 'mentorTecnico') {
            return new MentorTecnico(
                $row['id'],
                $row['nombre'],
                $row['email'],
                $row['nivel_habilidad'],
                $habilidades,
                $row['especialidad'] ?? '',
                (int)($row['experiencia'] ?? 0),
                $row['disponibilidad_horaria'] ?? ''
            );
        }
        
        throw new \Exception('Tipo de participante desconocido: ' . $row['tipo']);
    }
}