
const createEquiposPanel = () => {

    // Verificar que existan los stores necesarios
    const hackathonStore = Ext.getStore('hackathonStore');
    const participanteStore = Ext.getStore('participanteStore');
    const retoStore = Ext.getStore('retoStore');

    if (!hackathonStore) {
        throw new Error('hackathonStore no encontrado. Asegúrate de cargar hackathons.js antes de equipos.js');
    }

    // Modelo para Equipo
    Ext.define('App.model.Equipo', {
        extend: 'Ext.data.Model',
        fields: [
            { name: 'id', type: 'string' },
            { name: 'nombre', type: 'string' },
            { name: 'hackathonId', type: 'string' },
            { name: 'participantes', type: 'auto' }, // Array de objetos participante
            { name: 'retos', type: 'auto' }, // Array de objetos reto
            
            // Campo calculado para mostrar el nombre del hackathon
            {
                name: 'hackathonNombre',
                convert: function(v, record) {
                    const hackathonId = record.get('hackathonId');
                    if (hackathonId && hackathonStore) {
                        const hackathonRec = hackathonStore.findRecord('id', hackathonId);
                        return hackathonRec ? hackathonRec.get('nombre') : hackathonId;
                    }
                    return hackathonId;
                },
                persist: false
            }
        ]
    });

    const openDialog = (rec, isNew) => {
        const win = Ext.create('Ext.window.Window', {
            title: isNew ? 'Agregar Equipo' : 'Editar Equipo',
            modal: true,
            width: 640,
            height: 400,
            layout: 'fit',
            items: [{
                xtype: 'form',
                bodyPadding: 12,
                defaults: { anchor: '100%' },
                items: [
                    { xtype: 'hiddenfield', name: 'id' },
                    { xtype: 'textfield', name: 'nombre', fieldLabel: 'Nombre del Equipo', allowBlank: false },
                    {
                        xtype: 'combobox',
                        name: 'hackathonId',
                        fieldLabel: 'Hackathon',
                        store: hackathonStore,
                        queryMode: 'local',
                        valueField: 'id',
                        displayField: 'nombre',
                        forceSelection: true,
                        allowBlank: false
                    }
                ]
            }],
            buttons: [
                {
                    text: 'Guardar',
                    handler(button) {
                        const win = button.up('window');
                        const form = win.down('form').getForm();

                        if (!form.isValid()) return;

                        const values = form.getValues();
                        
                        // Generar ID si es nuevo
                        if (isNew && !values.id) {
                            values.id = 'equipo-' + Date.now();
                        }

                        form.updateRecord(rec);
                        if (isNew) equipoStore.add(rec);

                        equipoStore.sync({
                            success: () => {
                                Ext.Msg.alert('Éxito', 'Equipo guardado exitosamente.');
                                win.close();
                                equipoStore.load();
                            },
                            failure: (batch) => {
                                const error = batch.exceptions[0]?.getError()?.response?.responseText;
                                Ext.Msg.alert('Error', `Error al guardar equipo. ${error || ''}`);
                            }
                        });
                    },
                },
                {
                    text: 'Cancelar',
                    handler(button) {
                        button.up('window').close();
                    }
                }
            ]
        });
        
        win.down('form').loadRecord(rec);
        win.show();
    };

    const openParticipantesDialog = (equipo) => {
        const participantesGrid = Ext.create('Ext.grid.Panel', {
            store: participanteStore,
            columns: [
                { text: 'ID', dataIndex: 'id', width: 120 },
                { text: 'Nombre', dataIndex: 'nombre', flex: 1 },
                { text: 'Tipo', dataIndex: 'tipoDisplay', width: 120 }
            ],
            selModel: 'checkboxmodel',
            height: 300
        });

        const win = Ext.create('Ext.window.Window', {
            title: `Agregar Participantes a ${equipo.get('nombre')}`,
            modal: true,
            width: 600,
            height: 450,
            layout: 'fit',
            items: [
                {
                    xtype: 'form',
                    bodyPadding: 12,
                    items: [
                        {
                            xtype: 'fieldset',
                            title: 'Seleccionar Participantes',
                            items: [participantesGrid]
                        },
                        {
                            xtype: 'combobox',
                            name: 'rolEnEquipo',
                            fieldLabel: 'Rol en Equipo',
                            store: [
                                ['lider', 'Líder'],
                                ['desarrollador', 'Desarrollador'],
                                ['disenador', 'Diseñador'],
                                ['miembro', 'Miembro']
                            ],
                            valueField: 'value',
                            displayField: 'text',
                            queryMode: 'local',
                            value: 'miembro'
                        }
                    ]
                }
            ],
            buttons: [
                {
                    text: 'Agregar Participantes',
                    handler(button) {
                        const win = button.up('window');
                        const form = win.down('form').getForm();
                        const grid = win.down('grid');
                        const selections = grid.getSelectionModel().getSelection();
                        const rolEnEquipo = form.getValues().rolEnEquipo;

                        if (selections.length === 0) {
                            Ext.Msg.alert('Advertencia', 'Seleccione al menos un participante.');
                            return;
                        }

                        // Agregar cada participante seleccionado
                        let promises = selections.map(participante => {
                            return new Promise((resolve, reject) => {
                                Ext.Ajax.request({
                                    url: '/api/equipo.php',
                                    method: 'POST',
                                    jsonData: {
                                        action: 'addParticipante',
                                        equipoId: equipo.get('id'),
                                        participanteId: participante.get('id'),
                                        rolEnEquipo: rolEnEquipo
                                    },
                                    success: (response) => {
                                        const result = Ext.decode(response.responseText);
                                        if (result.success) {
                                            resolve();
                                        } else {
                                            reject('Error al agregar participante');
                                        }
                                    },
                                    failure: () => reject('Error de conexión')
                                });
                            });
                        });

                        Promise.all(promises).then(() => {
                            Ext.Msg.alert('Éxito', 'Participantes agregados exitosamente.');
                            win.close();
                            equipoStore.load();
                        }).catch(error => {
                            Ext.Msg.alert('Error', error);
                        });
                    }
                },
                {
                    text: 'Cancelar',
                    handler(button) {
                        button.up('window').close();
                    }
                }
            ]
        });

        win.show();
    };

    const openRetosDialog = (equipo) => {
        const retosGrid = Ext.create('Ext.grid.Panel', {
            store: retoStore,
            columns: [
                { text: 'ID', dataIndex: 'id', width: 120 },
                { text: 'Título', dataIndex: 'titulo', flex: 2 },
                { text: 'Complejidad', dataIndex: 'complejidad', width: 100 }
            ],
            selModel: 'checkboxmodel',
            height: 300
        });

        const win = Ext.create('Ext.window.Window', {
            title: `Asignar Retos a ${equipo.get('nombre')}`,
            modal: true,
            width: 600,
            height: 500,
            layout: 'fit',
            items: [
                {
                    xtype: 'form',
                    bodyPadding: 12,
                    items: [
                        {
                            xtype: 'fieldset',
                            title: 'Seleccionar Retos',
                            items: [retosGrid]
                        },
                        {
                            xtype: 'combobox',
                            name: 'estado',
                            fieldLabel: 'Estado',
                            store: [
                                ['asignado', 'Asignado'],
                                ['en_progreso', 'En Progreso'],
                                ['completado', 'Completado'],
                                ['abandonado', 'Abandonado']
                            ],
                            valueField: 'value',
                            displayField: 'text',
                            queryMode: 'local',
                            value: 'asignado'
                        },
                        {
                            xtype: 'numberfield',
                            name: 'progreso',
                            fieldLabel: 'Progreso (%)',
                            minValue: 0,
                            maxValue: 100,
                            value: 0
                        }
                    ]
                }
            ],
            buttons: [
                {
                    text: 'Asignar Retos',
                    handler(button) {
                        const win = button.up('window');
                        const form = win.down('form').getForm();
                        const grid = win.down('grid');
                        const selections = grid.getSelectionModel().getSelection();
                        const values = form.getValues();

                        if (selections.length === 0) {
                            Ext.Msg.alert('Advertencia', 'Seleccione al menos un reto.');
                            return;
                        }

                        // Asignar cada reto seleccionado
                        let promises = selections.map(reto => {
                            return new Promise((resolve, reject) => {
                                Ext.Ajax.request({
                                    url: '/api/equipo.php',
                                    method: 'POST',
                                    jsonData: {
                                        action: 'addReto',
                                        equipoId: equipo.get('id'),
                                        retoId: reto.get('id'),
                                        estado: values.estado,
                                        progreso: values.progreso
                                    },
                                    success: (response) => {
                                        const result = Ext.decode(response.responseText);
                                        if (result.success) {
                                            resolve();
                                        } else {
                                            reject('Error al asignar reto');
                                        }
                                    },
                                    failure: () => reject('Error de conexión')
                                });
                            });
                        });

                        Promise.all(promises).then(() => {
                            Ext.Msg.alert('Éxito', 'Retos asignados exitosamente.');
                            win.close();
                            equipoStore.load();
                        }).catch(error => {
                            Ext.Msg.alert('Error', error);
                        });
                    }
                },
                {
                    text: 'Cancelar',
                    handler(button) {
                        button.up('window').close();
                    }
                }
            ]
        });

        win.show();
    };

    const equipoStore = Ext.getStore('equipoStore') || Ext.create('Ext.data.Store', {
        storeId: 'equipoStore',
        model: 'App.model.Equipo',
        proxy: {
            type: 'rest',
            url: '/api/equipo.php',
            reader: { type: 'json', rootProperty: '' },
            writer: {
                type: 'json',
                rootProperty: '',
                writeAllFields: true
            },
            appendId: false
        },
        autoLoad: true,
        autoSync: false
    });

    return Ext.create('Ext.grid.Panel', {
        title: 'Equipos',
        itemId: 'equiposPanel',
        store: equipoStore,
        columns: [
            { text: 'ID', dataIndex: 'id', width: 120 },
            { text: 'Nombre', dataIndex: 'nombre', flex: 2 },
            { text: 'Hackathon', dataIndex: 'hackathonNombre', flex: 2 },
            { 
                text: 'Participantes', 
                dataIndex: 'participantes', 
                flex: 1,
                renderer: function(value) {
                    if (Array.isArray(value)) {
                        return `${value.length} participante(s)`;
                    }
                    return '0 participantes';
                }
            },
            { 
                text: 'Retos', 
                dataIndex: 'retos', 
                flex: 1,
                renderer: function(value) {
                    if (Array.isArray(value)) {
                        return `${value.length} reto(s)`;
                    }
                    return '0 retos';
                }
            }
        ],
        tbar: [
            {
                text: 'Agregar Equipo',
                handler: () => openDialog(Ext.create('App.model.Equipo'), true)
            },
            {
                text: 'Editar Equipo',
                handler(button) {
                    const grid = button.up('grid');
                    const selection = grid.getSelectionModel().getSelection();
                    if (selection.length > 0) {
                        openDialog(selection[0], false);
                    } else {
                        Ext.Msg.alert('Advertencia', 'Por favor seleccione un equipo para editar.');
                    }
                }
            },
            '-',
            {
                text: 'Agregar Participantes',
                handler(button) {
                    const grid = button.up('grid');
                    const selection = grid.getSelectionModel().getSelection();
                    if (selection.length > 0) {
                        openParticipantesDialog(selection[0]);
                    } else {
                        Ext.Msg.alert('Advertencia', 'Por favor seleccione un equipo.');
                    }
                }
            },
            {
                text: 'Asignar Retos',
                handler(button) {
                    const grid = button.up('grid');
                    const selection = grid.getSelectionModel().getSelection();
                    if (selection.length > 0) {
                        openRetosDialog(selection[0]);
                    } else {
                        Ext.Msg.alert('Advertencia', 'Por favor seleccione un equipo.');
                    }
                }
            },
            '-',
            {
                text: 'Eliminar',
                handler(button) {
                    const grid = button.up('grid');
                    const selection = grid.getSelectionModel().getSelection();

                    if (selection.length === 0) {
                        return Ext.Msg.alert('Advertencia', 'Seleccione un equipo');
                    }
                    
                    const rec = selection[0];

                    Ext.Msg.confirm('Confirmar', `¿Está seguro que desea eliminar "${rec.get('nombre')}"?`, btn => {
                        if (btn === 'yes') {
                            equipoStore.remove(rec);
                            equipoStore.sync({
                                success: () => Ext.Msg.alert('Éxito', 'Equipo eliminado exitosamente.'),
                                failure: () => Ext.Msg.alert('Error', 'Error al eliminar.')
                            });
                        }
                    });
                }
            }
        ],
    });
};

/* Exporta a ámbito global para app.js */
window.createEquiposPanel = createEquiposPanel;