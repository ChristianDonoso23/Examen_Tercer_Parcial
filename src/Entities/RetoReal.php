<?php

declare(strict_types=1);

class RetoReal extends RetoSolucionable
{
    private string $entidadColaboradora;

    public function __construct(string $titulo, string $descripcion, string $complejidad, string $areasConocimiento, string $entidadColaboradora)
    {
        parent::__construct($titulo, $descripcion, $complejidad, $areasConocimiento);
        $this->entidadColaboradora = $entidadColaboradora;
    }

    /*Getters*/
    public function getEntidadColaboradora(): string
    {
        return $this->entidadColaboradora;
    }

    /*Setters*/
    public function setEntidadColaboradora(string $entidadColaboradora): void
    {
        $this->entidadColaboradora = $entidadColaboradora;
    }
}