<?php
declare(strict_types=1);

namespace App\Entities;

class MentorTecnico extends Participante
{
    private string $especialidad;
    private int $experiencia;
    private string $disponibilidadHoraria;

    public function __construct(
        string $id, 
        string $nombre, 
        string $email, 
        string $nivelHabilidad, 
        array $habilidades,
        string $especialidad, 
        int $experiencia, 
        string $disponibilidadHoraria
    ) {
        parent::__construct($id, $nombre, $email, $nivelHabilidad, $habilidades);
        $this->especialidad = $especialidad;
        $this->experiencia = $experiencia;
        $this->disponibilidadHoraria = $disponibilidadHoraria;
    }

    // Getters
    public function getEspecialidad(): string
    {
        return $this->especialidad;
    }

    public function getExperiencia(): int
    {
        return $this->experiencia;
    }

    public function getDisponibilidadHoraria(): string
    {
        return $this->disponibilidadHoraria;
    }

    public function getTipo(): string
    {
        return 'mentorTecnico';
    }

    // Setters
    public function setEspecialidad(string $especialidad): void
    {
        $this->especialidad = $especialidad;
    }

    public function setDisponibilidadHoraria(string $disponibilidadHoraria): void
    {
        $this->disponibilidadHoraria = $disponibilidadHoraria;
    }

    public function setExperiencia(int $experiencia): void
    {
        $this->experiencia = $experiencia;
    }

    // Método específico para validar experiencia
    public function esExpertoEn(string $tecnologia): bool
    {
        return $this->experiencia >= 5 && in_array($tecnologia, $this->habilidades);
    }
}
