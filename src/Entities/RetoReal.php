<?php
declare(strict_types=1);

namespace App\Entities;

class RetoReal extends RetoSolucionable
{
    private string $entidadColaboradora;

    public function __construct(
        string $titulo, 
        string $descripcion, 
        string $complejidad, 
        array $areasConocimiento, 
        string $entidadColaboradora
    ) {
        parent::__construct($titulo, $descripcion, $complejidad, $areasConocimiento);
        $this->entidadColaboradora = $entidadColaboradora;
    }

    // Getters
    public function getEntidadColaboradora(): string
    {
        return $this->entidadColaboradora;
    }

    public function getTipo(): string
    {
        return 'retoReal';
    }

    // Setters
    public function setEntidadColaboradora(string $entidadColaboradora): void
    {
        $this->entidadColaboradora = $entidadColaboradora;
    }
}