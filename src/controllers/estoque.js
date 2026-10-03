const db = require ('../BANCO/connection');
 module.exports = {

    async criarEstoque(req, res) {
        try {
            const { nome, quantidade, preco } = req.body;
            const estoque_ativo = 1;

            const sql = `
             INSERT INTO estoque (nome, quantidade, preco, estoque_ativo)
             VALUES (?, ?, ?, ?)
            `;

            const values = [nome, quantidade, preco, estoque_ativo];

            const [result] = await db.query(sql, values);
            
            const dados = {
                id: result.insertId,
                nome,
                quantidade,
                preco,
                estoque_ativo
            };

            return response.status(200).json({
                sucesso: true, 
                mensagem: 'Estoque criado com sucesso',
                dados: dados
            });
        } catch (error) {
            return response.status(500).json({
                sucesso: false,
                mensagem: 'Erro ao criar estoque',
                dados: error.message 
            });
        }
    },

    
 }