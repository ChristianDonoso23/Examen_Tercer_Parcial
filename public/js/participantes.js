// participantes.js

const createParticipantesPanel = () => {

    // Modelo para Participante (maneja tanto estudiantes como mentores)
    Ext.define('App.model.Participante', {
        extend: 'Ext.data.Model',
        fields: [
            { name: 'id', type: 'string' },
            { name: 'nombre', type: 'string' },
            { name: 'email', type: 'string' },
            { name: 'nivelHabilidad', type: 'string' },
            { name: 'habilidades', type: 'auto' }, // Array
            { name: 'tipo', type: 'string' },
            
            // Campos específicos de Estudiante
            { name: 'grado', type: 'string' },
            { name: 'institucion', type: 'string' },
            { name: 'tiempoDisponibleSemanal', type: 'int' },
            
            // Campos específicos de Mentor Técnico
            { name: 'especialidad', type: 'string' },
            { name: 'experiencia', type: 'int' },
            { name: 'disponibilidadHoraria', type: 'string' },
            
            // Campo calculado para mostrar el tipo de participante
            {
                name: 'tipoDisplay',
                convert: function(v, record) {
                    const tipo = record.get('tipo');
                    return tipo === 'estudiante' ? 'Estudiante' : 
                           tipo === 'mentorTecnico' ? 'Mentor Técnico' : tipo;
                },
                persist: false
            }
        ]
    });

    const openDialog = (rec, isNew) => {
        // Campo para seleccionar tipo de participante
        const tipoCombo = Ext.create('Ext.form.field.ComboBox', {
            name: 'tipo',
            fieldLabel: 'Tipo',
            store: [
                ['estudiante', 'Estudiante'],
                ['mentorTecnico', 'Mentor Técnico']
            ],
            valueField: 'value',
            displayField: 'text',
            queryMode: 'local',
            allowBlank: false,
            value: rec.get('tipo') || 'estudiante',
            listeners: {
                change: function(combo, newValue) {
                    const form = combo.up('form');
                    const estudianteFields = form.query('[estudianteField=true]');
                    const mentorFields = form.query('[mentorField=true]');
                    
                    if (newValue === 'estudiante') {
                        estudianteFields.forEach(field => field.show());
                        mentorFields.forEach(field => field.hide());
                    } else {
                        estudianteFields.forEach(field => field.hide());
                        mentorFields.forEach(field => field.show());
                    }
                }
            }
        });

        const win = Ext.create('Ext.window.Window', {
            title: isNew ? 'Agregar Participante' : 'Editar Participante',
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
                    { xtype: 'textfield', name: 'nombre', fieldLabel: 'Nombre', allowBlank: false },
                    { xtype: 'textfield', name: 'email', fieldLabel: 'Email', allowBlank: false, vtype: 'email' },
                    {
                        xtype: 'combobox',
                        name: 'nivelHabilidad',
                        fieldLabel: 'Nivel de Habilidad',
                        store: [['basico', 'Básico'], ['intermedio', 'Intermedio'], ['avanzado', 'Avanzado']],
                        valueField: 'value',
                        displayField: 'text',
                        queryMode: 'local',
                        allowBlank: false
                    },
                    {
                        xtype: 'textareafield',
                        name: 'habilidadesText',
                        fieldLabel: 'Habilidades (separadas por comas)',
                        height: 60
                    },
                    tipoCombo,
                    
                    // Campos específicos para Estudiantes
                    {
                        xtype: 'combobox',
                        name: 'grado',
                        fieldLabel: 'Grado',
                        estudianteField: true,
                        store: [['6','6°'], ['7','7°'], ['8','8°'], ['9','9°'], ['10','10°'], ['11','11°'], ['12','12°']],
                        valueField: 'value',
                        displayField: 'text',
                        queryMode: 'local'
                    },
                    {
                        xtype: 'textfield',
                        name: 'institucion',
                        fieldLabel: 'Institución',
                        estudianteField: true
                    },
                    {
                        xtype: 'numberfield',
                        name: 'tiempoDisponibleSemanal',
                        fieldLabel: 'Tiempo Disponible Semanal (horas)',
                        estudianteField: true,
                        minValue: 1,
                        allowDecimals: false
                    },
                    
                    // Campos específicos para Mentores Técnicos
                    {
                        xtype: 'combobox',
                        name: 'especialidad',
                        fieldLabel: 'Especialidad',
                        mentorField: true,
                        store: [
                            ['Desarrollo Web', 'Desarrollo Web'],
                            ['Desarrollo Mobile', 'Desarrollo Mobile'],
                            ['Inteligencia Artificial', 'Inteligencia Artificial'],
                            ['Data Science', 'Data Science'],
                            ['UI/UX Design', 'UI/UX Design'],
                            ['Backend', 'Backend'],
                            ['Frontend', 'Frontend']
                        ],
                        valueField: 'value',
                        displayField: 'text',
                        queryMode: 'local'
                    },
                    {
                        xtype: 'numberfield',
                        name: 'experiencia',
                        fieldLabel: 'Años de Experiencia',
                        mentorField: true,
                        minValue: 0,
                        allowDecimals: false
                    },
                    {
                        xtype: 'textfield',
                        name: 'disponibilidadHoraria',
                        fieldLabel: 'Disponibilidad Horaria',
                        mentorField: true
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
                        
                        // Convertir habilidades de texto a array
                        if (values.habilidadesText) {
                            values.habilidades = values.habilidadesText.split(',').map(h => h.trim()).filter(h => h);
                            delete values.habilidadesText;
                        }
                        
                        // Generar ID si es nuevo
                        if (isNew && !values.id) {
                            values.id = 'participante-' + Date.now();
                        }

                        rec.set(values);
                        if (isNew) participanteStore.add(rec);

                        participanteStore.sync({
                            success: () => {
                                Ext.Msg.alert('Éxito', 'Participante guardado exitosamente.');
                                win.close();
                                participanteStore.load();
                            },
                            failure: (batch) => {
                                const error = batch.exceptions[0]?.getError()?.response?.responseText;
                                Ext.Msg.alert('Error', `Error al guardar participante. ${error || ''}`);
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
        
        // Convertir array de habilidades a texto para mostrar en el form
        if (rec.get('habilidades') && Array.isArray(rec.get('habilidades'))) {
            win.down('[name=habilidadesText]').setValue(rec.get('habilidades').join(', '));
        }
        
        // Configurar visibilidad inicial de campos
        const tipo = rec.get('tipo') || 'estudiante';
        tipoCombo.fireEvent('change', tipoCombo, tipo);
        
        win.show();
    };

    const participanteStore = Ext.getStore('participanteStore') || Ext.create('Ext.data.Store', {
        storeId: 'participanteStore',
        model: 'App.model.Participante',
        proxy: {
            type: 'rest',
            url: '/api/participante.php',
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
        title: 'Participantes',
        itemId: 'participantesPanel',
        store: participanteStore,
        columns: [
            { text: 'ID', dataIndex: 'id', width: 120 },
            { text: 'Nombre', dataIndex: 'nombre', flex: 1 },
            { text: 'Email', dataIndex: 'email', flex: 1 },
            { text: 'Tipo', dataIndex: 'tipoDisplay', width: 120 },
            { text: 'Nivel', dataIndex: 'nivelHabilidad', width: 100 },
            { 
                text: 'Habilidades', 
                dataIndex: 'habilidades', 
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
                    if (tipo === 'estudiante') {
                        return `Grado: ${record.get('grado')}, ${record.get('institucion')}`;
                    } else if (tipo === 'mentorTecnico') {
                        return `${record.get('especialidad')}, ${record.get('experiencia')} años exp.`;
                    }
                    return '';
                }
            }
        ],
        tbar: [
            {
                text: 'Agregar Participante',
                handler: () => openDialog(Ext.create('App.model.Participante'), true)
            },
            {
                text: 'Editar Participante',
                handler(button) {
                    const grid = button.up('grid');
                    const selection = grid.getSelectionModel().getSelection();
                    if (selection.length > 0) {
                        openDialog(selection[0], false);
                    } else {
                        Ext.Msg.alert('Advertencia', 'Por favor seleccione un participante para editar.');
                    }
                }
            },
            {
                text: 'Eliminar',
                handler(button) {
                    const grid = button.up('grid');
                    const selection = grid.getSelectionModel().getSelection();

                    if (selection.length === 0) {
                        return Ext.Msg.alert('Advertencia', 'Seleccione un participante');
                    }
                    
                    const rec = selection[0];

                    Ext.Msg.confirm('Confirmar', `¿Está seguro que desea eliminar a "${rec.get('nombre')}"?`, btn => {
                        if (btn === 'yes') {
                            participanteStore.remove(rec);
                            participanteStore.sync({
                                success: () => Ext.Msg.alert('Éxito', 'Participante eliminado exitosamente.'),
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
window.createParticipantesPanel = createParticipantesPanel;