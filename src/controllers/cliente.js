const db = require ('../BANCO/connection')
module.exports = {
    async listarClientes(req, res) {
        try {
            // throw new error ('Eu causei o erro');
            return response.status(200).json({
                sucesso: true,
                mensagem: 'Lista de clientes',
                dados: null
            });
        } catch (error) {
            return response.status(500).json({
                sucesso: false,
                mensagem: 'Erro ao listar clientes',
                dados: null
            });
        }
    },

    async cadastrarCliente(req, res) {
        try {
            return response.status(200).json({
                sucesso: true,
                mensagem: 'Cliente cadastrado com sucesso',
                dados: null
            });
        } catch (error) {
            return response.status(500).json({
                sucesso: false,
                mensagem: 'Erro na requisição',
                dados: null
            });
        }
    },
     async editarCliente(req, res) {
        try {
            return response.status(200).json({
                sucesso: true,
                mensagem:'Cliente editado com sucesso', 
                dados: null
            });
        } catch (error) {
            return response.status(500).json({
                sucesso: false,
                mensagem:'Erro ao editar o Cliente',
                dados: null
            });
        }
     },

     async deletarUsuario(request, response) {
        try{
            return response.status(200).json({
                sucesso: true,
                mensagem: 'Apagar usuário',
                dados: null
            });
        } catch (error) {
            return response.status(500).json({
                sucesso: false,
                mensagem: 'Erro na requisição',
                dados: error.message
            });
        }
    },
}