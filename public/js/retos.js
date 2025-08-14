// retos.js

const createRetosPanel = () => {

    // Modelo para Reto (maneja tanto reales como experimentales)
    Ext.define('App.model.Reto', {
        extend: 'Ext.data.Model',
        fields: [
            { name: 'id', type: 'string' },
            { name: 'titulo', type: 'string' },
            { name: 'descripcion', type: 'string' },
            { name: 'complejidad', type: 'string' },
            { name: 'areasConocimiento', type: 'auto' }, // Array
            { name: 'tipo', type: 'string' },
            
            // Campos específicos de Reto Real
            { name: 'entidadColaboradora', type: 'string' },
            
            // Campos específicos de Reto Experimental
            { name: 'enfoquePedagogico', type: 'string' },
            
            // Campo calculado para mostrar el tipo de reto
            {
                name: 'tipoDisplay',
                convert: function(v, record) {
                    const tipo = record.get('tipo');
                    return tipo === 'retoReal' ? 'Reto Real' : 
                           tipo === 'retoExperimental' ? 'Reto Experimental' : tipo;
                },
                persist: false
            }
        ]
    });

    const openDialog = (rec, isNew) => {
        // Campo para seleccionar tipo de reto
        const tipoCombo = Ext.create('Ext.form.field.ComboBox', {
            name: 'tipo',
            fieldLabel: 'Tipo de Reto',
            store: [
                ['retoReal', 'Reto Real'],
                ['retoExperimental', 'Reto Experimental']
            ],
            valueField: 'value',
            displayField: 'text',
            queryMode: 'local',
            allowBlank: false,
            value: rec.get('tipo') || 'retoReal',
            listeners: {
                change: function(combo, newValue) {
                    const form = combo.up('form');
                    const realFields = form.query('[retoRealField=true]');
                    const experimentalFields = form.query('[retoExperimentalField=true]');
                    
                    if (newValue === 'retoReal') {
                        realFields.forEach(field => field.show());
                        experimentalFields.forEach(field => field.hide());
                    } else {
                        realFields.forEach(field => field.hide());
                        experimentalFields.forEach(field => field.show());
                    }
                }
            }
        });

        const win = Ext.create('Ext.window.Window', {
            title: isNew ? 'Agregar Reto' : 'Editar Reto',
            modal: true,
            width: 640,
            height: 500,
            layout: 'fit',
            items: [{
                xtype: 'form',
                bodyPadding: 12,
                defaults: { anchor: '100%' },
                items: [
                    { xtype: 'hiddenfield', name: 'id' },
                    { xtype: 'textfield', name: 'titulo', fieldLabel: 'Título', allowBlank: false },
                    { xtype: 'textareafield', name: 'descripcion', fieldLabel: 'Descripción', height: 80, allowBlank: false },
                    {
                        xtype: 'combobox',
                        name: 'complejidad',
                        fieldLabel: 'Complejidad',
                        store: [['facil', 'Fácil'], ['media', 'Media'], ['dificil', 'Difícil']],
                        valueField: 'value',
                        displayField: 'text',
                        queryMode: 'local',
                        allowBlank: false
                    },
                    {
                        xtype: 'textareafield',
                        name: 'areasConocimientoText',
                        fieldLabel: 'Áreas de Conocimiento (separadas por comas)',
                        height: 60
                    },
                    tipoCombo,
                    
                    // Campos específicos para Retos Reales
                    {
                        xtype: 'textfield',
                        name: 'entidadColaboradora',
                        fieldLabel: 'Entidad Colaboradora',
                        retoRealField: true
                    },
                    
                    // Campos específicos para Retos Experimentales
                    {
                        xtype: 'textfield',
                        name: 'enfoquePedagogico',
                        fieldLabel: 'Enfoque Pedagógico',
                        retoExperimentalField: true
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
                        
                        // Convertir áreas de conocimiento de texto a array
                        if (values.areasConocimientoText) {
                            values.areasConocimiento = values.areasConocimientoText.split(',').map(a => a.trim()).filter(a => a);
                            delete values.areasConocimientoText;
                        }
                        
                        // Generar ID si es nuevo
                        if (isNew && !values.id) {
                            values.id = 'reto-' + Date.now();
                        }

                        rec.set(values);
                        if (isNew) retoStore.add(rec);

                        retoStore.sync({
                            success: () => {
                                Ext.Msg.alert('Éxito', 'Reto guardado exitosamente.');
                                win.close();
                                retoStore.load();
                            },
                            failure: (batch) => {
                                const error = batch.exceptions[0]?.getError()?.response?.responseText;
                                Ext.Msg.alert('Error', `Error al guardar reto. ${error || ''}`);
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
        
        // Cargar el registro y configurar campos visibles
        win.down('form').loadRecord(rec);
        
        // Convertir array de áreas de conocimiento a texto para mostrar en el form
        if (rec.get('areasConocimiento') && Array.isArray(rec.get('areasConocimiento'))) {
            win.down('[name=areasConocimientoText]').setValue(rec.get('areasConocimiento').join(', '));
        }
        
        // Configurar visibilidad inicial de campos
        const tipo = rec.get('tipo') || 'retoReal';
        tipoCombo.fireEvent('change', tipoCombo, tipo);
        
        win.show();
    };

    const retoStore = Ext.getStore('retoStore') || Ext.create('Ext.data.Store', {
        storeId: 'retoStore',
        model: 'App.model.Reto',
        proxy: {
            type: 'rest',
            url: '/api/reto.php',
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
        title: 'Retos',
        itemId: 'retosPanel',
        store: retoStore,
        columns: [
            { text: 'ID', dataIndex: 'id', width: 120 },
            { text: 'Título', dataIndex: 'titulo', flex: 2 },
            { text: 'Tipo', dataIndex: 'tipoDisplay', width: 130 },
            { text: 'Complejidad', dataIndex: 'complejidad', width: 100 },
            { 
                text: 'Áreas de Conocimiento', 
                dataIndex: 'areasConocimiento', 
                flex: 1,
                renderer: function(value) {
                    return Array.isArray(value) ? value.join(', ') : value;
                }
            },
            {
                text: 'Info Específica',
                flex: 1,
                renderer: function(value, metaData, record) {
                    const tipo = record.get('tipo');
                    if (tipo === 'retoReal') {
                        return `Entidad: ${record.get('entidadColaboradora') || 'N/A'}`;
                    } else if (tipo === 'retoExperimental') {
                        return `Enfoque: ${record.get('enfoquePedagogico') || 'N/A'}`;
                    }
                    return '';
                }
            }
        ],
        tbar: [
            {
                text: 'Agregar Reto',
                handler: () => openDialog(Ext.create('App.model.Reto'), true)
            },
            {
                text: 'Editar Reto',
                handler(button) {
                    const grid = button.up('grid');
                    const selection = grid.getSelectionModel().getSelection();
                    if (selection.length > 0) {
                        openDialog(selection[0], false);
                    } else {
                        Ext.Msg.alert('Advertencia', 'Por favor seleccione un reto para editar.');
                    }
                }
            },
            {
                text: 'Eliminar',
                handler(button) {
                    const grid = button.up('grid');
                    const selection = grid.getSelectionModel().getSelection();

                    if (selection.length === 0) {
                        return Ext.Msg.alert('Advertencia', 'Seleccione un reto');
                    }
                    
                    const rec = selection[0];

                    Ext.Msg.confirm('Confirmar', `¿Está seguro que desea eliminar "${rec.get('titulo')}"?`, btn => {
                        if (btn === 'yes') {
                            retoStore.remove(rec);
                            retoStore.sync({
                                success: () => Ext.Msg.alert('Éxito', 'Reto eliminado exitosamente.'),
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
window.createRetosPanel = createRetosPanel;