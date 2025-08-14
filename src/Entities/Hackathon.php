<?php
declare(strict_types=1);

namespace App\Entities;

class Hackathon 
{
    private string $id;
    private string $nombre;
    private string $descripcion;
    private string $fechaInicio;
    private string $fechaFin;
    private string $lugar;
    private string $estado;

    public function __construct(
        string $nombre,
        string $descripcion,
        string $fechaInicio,
        string $fechaFin,
        string $lugar,
        string $estado = 'planificado'
    ) {
        $this->nombre = $nombre;
        $this->descripcion = $descripcion;
        $this->fechaInicio = $fechaInicio;
        $this->fechaFin = $fechaFin;
        $this->lugar = $lugar;
        $this->estado = $estado;
    }

    // Getters
    public function getId(): string
    {
        return $this->id;
    }

    public function getNombre(): string
    {
        return $this->nombre;
    }

    public function getDescripcion(): string
    {
        return $this->descripcion;
    }

    public function getFechaInicio(): string
    {
        return $this->fechaInicio;
    }

    public function getFechaFin(): string
    {
        return $this->fechaFin;
    }

    public function getLugar(): string
    {
        return $this->lugar;
    }

    public function getEstado(): string
    {
        return $this->estado;
    }

    // Setters
    public function setId(string $id): void
    {
        $this->id = $id;
    }

    public function setNombre(string $nombre): void
    {
        $this->nombre = $nombre;
    }

    public function setDescripcion(string $descripcion): void
    {
        $this->descripcion = $descripcion;
    }

    public function setFechaInicio(string $fechaInicio): void
    {
        $this->fechaInicio = $fechaInicio;
    }

    public function setFechaFin(string $fechaFin): void
    {
        $this->fechaFin = $fechaFin;
    }

    public function setLugar(string $lugar): void
    {
        $this->lugar = $lugar;
    }

    public function setEstado(string $estado): void
    {
        $this->estado = $estado;
    }
}