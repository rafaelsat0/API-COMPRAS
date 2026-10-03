const db = require ('../BANCO/connection');
module.exports = {

    async criarProduto(req, res) {
        try {
            const { nome, unidade_medida, preco_atual} = req.body;
             
            const produto_ativo = 1;

            if (!nome || !unidade_medida || !preco_atual == undefined) {
                return res.status(400).json({
                    sucesso: false,
                    mensagem:'Nome todos os campos são obrigatórios',
                });
            }

            if (preco_atual < 0) {
                return res.status(400).json({
                    sucesso: false,
                    mensagem: 'O preço atual não pode ser negativo'
                });
            }


            
            const sql = `
             INSERT INTO produto (nome, unidade_medida, preco_atual, produto_ativo)
             VALUES (?, ?, ?, ?)
            `;

            const values = [nome, unidade_medida, preco_atual, produto_ativo];

            const [result] = await db.query(sql, values);

            const dados = {
                id: result.insertId,
                nome,
                unidade_medida,
                preco_atual,
                produto_ativo
            };

            return res.status(201).json({
                sucesso: true,
                mensagem: 'Produto criado com sucesso',
                dados: dados
            });
        } catch (error) {
            return res.status(500).json({
                sucesso: false,
                mensagem: 'Erro ao criar produto',
                dados: error.message
            });
        }
    }
}