<?php
declare(strict_types=1);

namespace App\Entities;

class Estudiante extends Participante
{
    private string $grado;
    private string $institucion;
    private int $tiempoDisponibleSemanal;

    public function __construct(
        string $id, 
        string $nombre, 
        string $email, 
        string $nivelHabilidad, 
        array $habilidades,
        string $grado, 
        string $institucion, 
        int $tiempoDisponibleSemanal
    ) {
        parent::__construct($id, $nombre, $email, $nivelHabilidad, $habilidades);
        $this->grado = $grado;
        $this->institucion = $institucion;
        $this->tiempoDisponibleSemanal = $tiempoDisponibleSemanal;
    }

    // Getters
    public function getGrado(): string
    {
        return $this->grado;
    }

    public function getInstitucion(): string
    {
        return $this->institucion;
    }

    public function getTiempoDisponibleSemanal(): int
    {
        return $this->tiempoDisponibleSemanal;
    }

    public function getTipo(): string
    {
        return 'estudiante';
    }

    // Setters
    public function setGrado(string $grado): void
    {
        $this->grado = $grado;
    }

    public function setInstitucion(string $institucion): void
    {
        $this->institucion = $institucion;
    }

    public function setTiempoDisponibleSemanal(int $tiempoDisponibleSemanal): void
    {
        $this->tiempoDisponibleSemanal = $tiempoDisponibleSemanal;
    }

    // Método específico para validar disponibilidad
    public function tieneDisponibilidadMinima(int $horasRequeridas): bool
    {
        return $this->tiempoDisponibleSemanal >= $horasRequeridas;
    }
}