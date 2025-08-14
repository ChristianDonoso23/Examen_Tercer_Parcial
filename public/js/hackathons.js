
const createHackathonsPanel = () => {

    // Modelo para Hackathon
    Ext.define('App.model.Hackathon', {
        extend: 'Ext.data.Model',
        fields: [
            { name: 'id', type: 'string' },
            { name: 'nombre', type: 'string' },
            { name: 'descripcion', type: 'string' },
            { name: 'fechaInicio', type: 'date', dateFormat: 'Y-m-d' },
            { name: 'fechaFin', type: 'date', dateFormat: 'Y-m-d' },
            { name: 'lugar', type: 'string' },
            { name: 'estado', type: 'string' },
            
            // Campo calculado para mostrar el estado
            {
                name: 'estadoDisplay',
                convert: function(v, record) {
                    const estado = record.get('estado');
                    switch(estado) {
                        case 'planificado': return 'Planificado';
                        case 'activo': return 'Activo';
                        case 'finalizado': return 'Finalizado';
                        default: return estado;
                    }
                },
                persist: false
            }
        ]
    });

    const openDialog = (rec, isNew) => {
        const win = Ext.create('Ext.window.Window', {
            title: isNew ? 'Agregar Hackathon' : 'Editar Hackathon',
            modal: true,
            width: 640,
            height: 450,
            layout: 'fit',
            items: [{
                xtype: 'form',
                bodyPadding: 12,
                defaults: { anchor: '100%' },
                items: [
                    { xtype: 'hiddenfield', name: 'id' },
                    { xtype: 'textfield', name: 'nombre', fieldLabel: 'Nombre', allowBlank: false },
                    { xtype: 'textareafield', name: 'descripcion', fieldLabel: 'Descripción', height: 80, allowBlank: false },
                    {
                        xtype: 'datefield',
                        name: 'fechaInicio',
                        fieldLabel: 'Fecha de Inicio',
                        format: 'Y-m-d',
                        submitFormat: 'Y-m-d',
                        allowBlank: false
                    },
                    {
                        xtype: 'datefield',
                        name: 'fechaFin',
                        fieldLabel: 'Fecha de Fin',
                        format: 'Y-m-d',
                        submitFormat: 'Y-m-d',
                        allowBlank: false
                    },
                    { xtype: 'textfield', name: 'lugar', fieldLabel: 'Lugar', allowBlank: false },
                    {
                        xtype: 'combobox',
                        name: 'estado',
                        fieldLabel: 'Estado',
                        store: [
                            ['planificado', 'Planificado'],
                            ['activo', 'Activo'],
                            ['finalizado', 'Finalizado']
                        ],
                        valueField: 'value',
                        displayField: 'text',
                        queryMode: 'local',
                        allowBlank: false,
                        value: 'planificado'
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
                            values.id = 'hackathon-' + Date.now();
                        }

                        form.updateRecord(rec);
                        if (isNew) hackathonStore.add(rec);

                        hackathonStore.sync({
                            success: () => {
                                Ext.Msg.alert('Éxito', 'Hackathon guardado exitosamente.');
                                win.close();
                                hackathonStore.load();
                            },
                            failure: (batch) => {
                                const error = batch.exceptions[0]?.getError()?.response?.responseText;
                                Ext.Msg.alert('Error', `Error al guardar hackathon. ${error || ''}`);
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

    const hackathonStore = Ext.getStore('hackathonStore') || Ext.create('Ext.data.Store', {
        storeId: 'hackathonStore',
        model: 'App.model.Hackathon',
        proxy: {
            type: 'rest',
            url: '/api/hackathon.php',
            reader: { type: 'json', rootProperty: '' },
            writer: {
                type: 'json',
                rootProperty: '',
                writeAllFields: true,
                // Transforma los datos antes de enviarlos al servidor
                transform: (data, request) => {
                    const transformedData = {};
                    
                    Ext.Object.each(data, (key, value) => {
                        if (key === 'fechaInicio' || key === 'fechaFin') {
                            // Formatear fechas
                            transformedData[key] = Ext.Date.format(value, 'Y-m-d');
                        } else if (key !== 'estadoDisplay') { // Excluir campos no persistentes
                            transformedData[key] = value;
                        }
                    });
                    
                    return transformedData;
                }
            },
            appendId: false
        },
        autoLoad: true,
        autoSync: false
    });

    return Ext.create('Ext.grid.Panel', {
        title: 'Hackathons',
        itemId: 'hackathonsPanel',
        store: hackathonStore,
        columns: [
            { text: 'ID', dataIndex: 'id', width: 120 },
            { text: 'Nombre', dataIndex: 'nombre', flex: 2 },
            { text: 'Lugar', dataIndex: 'lugar', flex: 1 },
            { text: 'Fecha Inicio', dataIndex: 'fechaInicio', xtype: 'datecolumn', format: 'Y-m-d', width: 110 },
            { text: 'Fecha Fin', dataIndex: 'fechaFin', xtype: 'datecolumn', format: 'Y-m-d', width: 110 },
            { text: 'Estado', dataIndex: 'estadoDisplay', width: 100 },
            { 
                text: 'Descripción', 
                dataIndex: 'descripcion', 
                flex: 2,
                renderer: function(value) {
                    // Truncar descripción larga para mostrar en grid
                    return value && value.length > 50 ? value.substring(0, 50) + '...' : value;
                }
            }
        ],
        tbar: [
            {
                text: 'Agregar Hackathon',
                handler: () => openDialog(Ext.create('App.model.Hackathon'), true)
            },
            {
                text: 'Editar Hackathon',
                handler(button) {
                    const grid = button.up('grid');
                    const selection = grid.getSelectionModel().getSelection();
                    if (selection.length > 0) {
                        openDialog(selection[0], false);
                    } else {
                        Ext.Msg.alert('Advertencia', 'Por favor seleccione un hackathon para editar.');
                    }
                }
            },
            {
                text: 'Eliminar',
                handler(button) {
                    const grid = button.up('grid');
                    const selection = grid.getSelectionModel().getSelection();

                    if (selection.length === 0) {
                        return Ext.Msg.alert('Advertencia', 'Seleccione un hackathon');
                    }
                    
                    const rec = selection[0];

                    Ext.Msg.confirm('Confirmar', `¿Está seguro que desea eliminar "${rec.get('nombre')}"?`, btn => {
                        if (btn === 'yes') {
                            hackathonStore.remove(rec);
                            hackathonStore.sync({
                                success: () => Ext.Msg.alert('Éxito', 'Hackathon eliminado exitosamente.'),
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
window.createHackathonsPanel = createHackathonsPanel;