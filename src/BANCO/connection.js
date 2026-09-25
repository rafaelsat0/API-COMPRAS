require ('dontenv').config();
const mysql = require('mysql2/promise');

//configuração para o banco de dados referente ao .env 

const config = {
    host: process.env.BD_SERVIDOR,
    port: process.env.BD_SERVIDOR_PORT,
    user: process.env.BD_USARIO,
    password: process.env.BD_SENHA,
    database: process.env.BD_BANCO,
    waitForConnections: true,
    connectionLimit: 10, // Auto ajustavél conforme a demanda de requisições, posso controlar caso tenha um DOS por aqui?
    queueLimit: 0,   
};
let pool;

const initilizeDatabase = async () => {
    try {
        // Vai criar uma Pool de conexões com o bando de dados.
        pool = mysql.createPool(config);
        // testa a conexão com o banco de dados 
        const connection = await pool.getConnection();
        console.log('Conexão com o banco de dados estabelecida com sucesso!');
        connection.realease(); // Libera a conexão de volta ao pool
    } catch (error) {
        console.error('Erro ao conectar com um banco de dados:', error),
        process.exit(1); // Encerra o processo com um código de erro
    }
};
// inicializa a conexão com o banco de dados

inicilizeDatabase();

module.exports = pool;
