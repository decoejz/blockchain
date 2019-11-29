pragma solidity >=0.4.2 <0.7.0;

//Referencia para o codigo:
//https://www.dappuniversity.com/articles/the-ultimate-ethereum-dapp-tutorial

//truffle migrate --reset
//truffle console
//Election.deployed().then(function(instance) { app = instance })
//app.Candidatos(1)
contract Election {
    //Adicionar vencedor
    //Adicionar candidato apenas o dono do contrato
    //Lista os candidatos em ordem de quantidade de votos
    //Adicionar lista de eleitores

    // Modela um candidato
    struct Candidato {
        uint id;
        string nome;
        string proposta;
        uint contagem;
    }

    // Cria um array de candidatos
    mapping(uint => Candidato) public Candidatos;

    // Salva em um endereco se o voto ja aconteceu ou nao
    mapping(address => bool) public voters;

    // Guarda o total de candidatos que tem em uma eleicao
    uint public totalCandidatos = 1;

    // Inicializa a eleicao com os candidatos
    constructor () public {
        addCandidato("Candidato 1","Proposta do candidato 1");
        addCandidato("Candidato 2","Proposta do candidato 2");
        addCandidato("Candidato 3","Proposta do candidato 3");
    }

    event votedEvent (
        uint indexed _CandidatoId
    );

    function addCandidato (string memory _name, string memory _proposta) private {
        // Cria um novo candidato
        Candidatos[totalCandidatos] = Candidato(totalCandidatos-1, _name, _proposta, 0);

        // Adiciona 1 nos valores de id
        totalCandidatos ++;
    }

    function vote (uint _CandidatoId) public {
        // Garante que a pessoa ainda não tenha votado
        // Caso ja tinha votado, ele sai da funcao
        require(!voters[msg.sender]);

        // Garante que o candidato exista
        // Caso o candidato nao exista, ele sai da funcao
        require(_CandidatoId > 0 && _CandidatoId <= totalCandidatos);

        // Muda o estado do eleitor dizendo que ele votou
        voters[msg.sender] = true;

        // Atualiza a quantidade de votos de um candidato
        Candidatos[_CandidatoId].contagem = Candidatos[_CandidatoId].contagem + 1;

        // trigger voted event
        emit votedEvent(_CandidatoId);
    }

    function visualizaVotosCandidato(uint _CandidatoId) public view returns (uint votos) {
        return Candidatos[_CandidatoId].contagem;
    }

    function vencedor() public view returns (string memory nome, uint totalVotos){
        totalVotos = 0;
        for (uint p = 0; p < totalCandidatos; p++) {
            if (Candidatos[p].contagem > totalVotos) {
                totalVotos = Candidatos[p].contagem;
                nome = Candidatos[p].nome;
            }
        }
    }
}