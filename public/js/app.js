Ext.onReady(() => {
    // Crear cada panel invocando la función de su archivo
    const participantesPanel = createParticipantesPanel();
    const retosPanel = createRetosPanel();
    const hackathonsPanel = createHackathonsPanel();
    const equiposPanel = createEquiposPanel();

    // Panel principal con Card Layout
    const mainCard = Ext.create('Ext.panel.Panel', {
        region: 'center',
        layout: 'card',
        items: [hackathonsPanel, participantesPanel, retosPanel, equiposPanel]
    });

    // Viewport con navbar arriba
    Ext.create('Ext.container.Viewport', {
        id: 'mainViewport',
        layout: 'border',
        items: [
            {
                region: 'north',
                xtype: 'toolbar',
                height: 40,
                items: [
                    {
                        text: 'Hackathons',
                        handler: () => mainCard.getLayout().setActiveItem(hackathonsPanel)
                    },
                    {
                        text: 'Participantes',
                        handler: () => mainCard.getLayout().setActiveItem(participantesPanel)
                    },
                    {
                        text: 'Retos',
                        handler: () => mainCard.getLayout().setActiveItem(retosPanel)
                    },
                    {
                        text: 'Equipos',
                        handler: () => mainCard.getLayout().setActiveItem(equiposPanel)
                    }
                ]
            },
            mainCard
        ]
    });
});