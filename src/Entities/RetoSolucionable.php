<?php
declare(strict_types=1);

namespace App\Entities;

abstract class RetoSolucionable 
{
    protected string $id;
    protected string $titulo;
    protected string $descripcion;
    protected string $complejidad;
    protected array $areasConocimiento; 

    public function __construct(
        string $titulo, 
        string $descripcion, 
        string $complejidad, 
        array $areasConocimiento
    ) {
        $this->titulo = $titulo;
        $this->descripcion = $descripcion;
        $this->complejidad = $complejidad;
        $this->areasConocimiento = $areasConocimiento;
    }

    // Getters
    public function getId(): string
    {
        return $this->id;
    }

    public function getTitulo(): string
    {
        return $this->titulo;
    }

    public function getDescripcion(): string
    {
        return $this->descripcion;
    }

    public function getComplejidad(): string
    {
        return $this->complejidad;
    }

    public function getAreasConocimiento(): array
    {
        return $this->areasConocimiento;
    }

    // Setters
    public function setId(string $id): void
    {
        $this->id = $id;
    }

    public function setTitulo(string $titulo): void
    {
        $this->titulo = $titulo;
    }

    public function setDescripcion(string $descripcion): void
    {
        $this->descripcion = $descripcion;
    }

    public function setComplejidad(string $complejidad): void
    {
        $this->complejidad = $complejidad;
    }

    public function setAreasConocimiento(array $areasConocimiento): void
    {
        $this->areasConocimiento = $areasConocimiento;
    }

    public function requiereArea(string $area): bool
    {
        return in_array($area, $this->areasConocimiento);
    }

    public function getDificultadNumerica(): int
    {
        return match($this->complejidad) {
            'facil' => 1,
            'media' => 2,
            'dificil' => 3,
            default => 0
        };
    }

    // Método abstracto
    abstract public function getTipo(): string;
}
