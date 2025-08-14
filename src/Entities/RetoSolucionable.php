<?php

declare(strict_types=1);

abstract class RetoSolucionable {
    protected string $titulo;
    protected string $descripcion;
    protected string $complejidad;
    protected string $areasConocimiento;

    public function __construct(string $titulo, string $descripcion, string $complejidad, string $areasConocimiento)
    {
        $this->titulo = $titulo;
        $this->descripcion = $descripcion;
        $this->complejidad = $complejidad;
        $this->areasConocimiento = $areasConocimiento;
    }

    /*Getters*/
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

    public function getAreasConocimiento(): string
    {
        return $this->areasConocimiento;
    }

    /*Setters*/
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

    public function setAreasConocimiento(string $areasConocimiento): void
    {
        $this->areasConocimiento = $areasConocimiento;
    }
}