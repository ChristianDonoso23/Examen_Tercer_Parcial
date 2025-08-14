<?php

declare(strict_types=1);

use App\Entities\Participante;

class Equipo 
{
    protected string $nombre;
    protected string $hackathonId;
    protected Participante $participante;

    public function __construct(
        string $nombre, 
        string $hackathonId, 
        Participante $participante
    ) {
        $this->nombre = $nombre;
        $this->hackathonId = $hackathonId;
        $this->participante = $participante;
    }

    /*Getters*/
    public function getNombre(): string {
        return $this->nombre;
    }

    public function getHackathonId(): string {
        return $this->hackathonId;
    }

    public function getParticipante(): Participante {
        return $this->participante;
    }

    /*Setters*/
    public function setNombre(string $nombre): void {
        $this->nombre = $nombre;
    }

    public function setHackathonId(string $hackathonId): void {
        $this->hackathonId = $hackathonId;
    }

    public function setParticipante(Participante $participante): void {
        $this->participante = $participante;
    }
}