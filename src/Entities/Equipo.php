<?php
declare(strict_types=1);

namespace App\Entities;

class Equipo
{
    private string $id;
    private string $nombre;
    private string $hackathonId;
    private array $participantes;
    private array $retos;

    public function __construct(
        string $nombre,
        string $hackathonId,
        array $participantes = []
    ) {
        $this->nombre = $nombre;
        $this->hackathonId = $hackathonId;
        $this->participantes = $participantes;
        $this->retos = [];
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

    public function getHackathonId(): string
    {
        return $this->hackathonId;
    }

    public function getParticipantes(): array
    {
        return $this->participantes;
    }

    public function getRetos(): array
    {
        return $this->retos;
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

    public function setHackathonId(string $hackathonId): void
    {
        $this->hackathonId = $hackathonId;
    }

    public function setParticipantes(array $participantes): void
    {
        $this->participantes = $participantes;
    }

    public function setRetos(array $retos): void
    {
        $this->retos = $retos;
    }
}
