## Como funciona?

Primeiro passo o usuario vai entrar no app e uma chave publica privada.

## importante lembrar

- Chave publica fica disponivel pra todo mundo ver e é usada para criptografar os dados

- Chave privada somente o usuario pode ter, nao pode esquece-la e é usada para descriptografar os dados.

## Tecnologias utilizadas

- Através da rede da Ethereum, vamos utilizar smart contracts para fazer cada transacao das consultas do paciente no hospital  
    - Ex: Assim que o paciente chegar no atendimento a atendente vai escanear o QRCode do paciente (chave publica) e vai colocar no smart contract.

- A solução pode ser escalavel para um blockchain permissionado, onde nao teremos tantos problemas com o "gas" do contrato.

- No lado do aplicativo estamos utilizando Flutter com as bibliotecas "web3dart","qr_flutter" assim temos um app para Android e Iphone.

- No consultorio medico, temos o framework Laravel juntamente com a biblioteca javascript "Web3" para realizar a conexao com o MetaMask e entao cadastrar a ação que esta acontecendo ("tirando exame de sangue...")