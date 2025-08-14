<?php

declare(strict_types=1);

class RetoExperimental extends RetoSolucionable
{
    private string $enfoquePedagogico;
    public function __construct(string $titulo, string $descripcion, string $complejidad, string $areasConocimiento, string $enfoquePedagogico)
    {
        parent::__construct($titulo, $descripcion, $complejidad, $areasConocimiento);
        $this->enfoquePedagogico = $enfoquePedagogico;
    }

    /*Getters*/
    public function getEnfoquePedagogico(): string
    {
        return $this->enfoquePedagogico;
    }

    /*Setters*/
    public function setEnfoquePedagogico(string $enfoquePedagogico): void
    {
        $this->enfoquePedagogico = $enfoquePedagogico;
    }
}