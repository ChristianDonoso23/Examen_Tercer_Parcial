<?php
declare(strict_types=1);

namespace App\Entities;

abstract class Participante
{
    protected string $id;
    protected string $nombre;
    protected string $email;
    protected string $nivelHabilidad;
    protected array $habilidades; 

    public function __construct(
        string $id,
        string $nombre,
        string $email,
        string $nivelHabilidad,
        array $habilidades = []
    ) {
        $this->id = $id;
        $this->nombre = $nombre;
        $this->email = $email;
        $this->nivelHabilidad = $nivelHabilidad;
        $this->habilidades = $habilidades;
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

    public function getEmail(): string
    {
        return $this->email;
    }

    public function getNivelHabilidad(): string
    {
        return $this->nivelHabilidad;
    }

    public function getHabilidades(): array
    {
        return $this->habilidades;
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

    public function setEmail(string $email): void
    {
        $this->email = $email;
    }

    public function setNivelHabilidad(string $nivelHabilidad): void
    {
        $this->nivelHabilidad = $nivelHabilidad;
    }

    public function setHabilidades(array $habilidades): void
    {
        $this->habilidades = $habilidades;
    }

    // Metodos adicionales para manejar habilidades
    public function addHabilidad(string $habilidad): void
    {
        if (!in_array($habilidad, $this->habilidades)) {
            $this->habilidades[] = $habilidad;
        }
    }

    public function removeHabilidad(string $habilidad): void
    {
        $this->habilidades = array_filter($this->habilidades, fn($h) => $h !== $habilidad);
    }

    public function hasHabilidad(string $habilidad): bool
    {
        return in_array($habilidad, $this->habilidades);
    }

    // Método abstracto que pueden implementar las clases hijas
    abstract public function getTipo(): string;
}
