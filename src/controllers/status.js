const db = require('../BANCO/connection');

module.exports = {
    async listarStatus(req, res) {
        try {
            const [status] = await db.query('SELECT * FROM status');
            return res.status(200).json({
                sucesso: true,
                mensagem: 'Lista de status',
                dados: status
            });
        } catch (error) {
            return res.status(500).json({
                sucesso: false,
                mensagem: 'Erro ao listar status',
                dados: error.message
            });
        }
    },

    async cadastrarStatus(req, res) {
        try {
            const { nome } = req.body;
            const [resultado] = await db.query('INSERT INTO status (nome) VALUES (?)', [nome]);

            return res.status(201).json({
                sucesso: true,
                mensagem: 'Status cadastrado com sucesso',
                dados: resultado
            });
        } catch (error) {
            return res.status(500).json({
                sucesso: false,
                mensagem: 'Erro ao cadastrar status',
                dados: error.message
            });
        }
    }
};