pragma solidity >=0.4.2 <0.7.0;

//Referencia para o codigo:
//https://www.dappuniversity.com/articles/the-ultimate-ethereum-dapp-tutorial

//truffle migrate --reset
//truffle console
//Election.deployed().then(function(instance) { app = instance })
//app.Candidatos(1)
contract Election {
    
    // Funcao que torna o vencedor - OK
    // Adicionar candidato apenas o criador do contrato - OK
    // Lista os candidatos em ordem de quantidade de votos
    // Adicionar lista de eleitores - OK
    // Garantir que haverá apenas um voto por eleitor

    // Modela um candidato
    struct Candidato {
        uint id;
        string nome;
        string proposta;
        uint contagem;
    }

    struct Eleitor {
        uint id;
        bool votado;
        address conta;
    }

    // Cria uma lista de candidatos
    mapping(uint => Candidato) public Candidatos;

    // Cria uma lista de eleitores
    mapping(uint => Eleitor) public Eleitores;

    // // NÃO SERA MAIS NECESSARIO QUANDO TIVER A LISTA DE ELEITORES
    // // Salva em um endereco se o voto ja aconteceu ou nao
    // mapping(address => bool) public voters;

    // Guarda o total de candidatos que tem em uma eleicao
    uint public totalCandidatos = 1;

    // Guarda o total de candidatos que tem em uma eleicao
    uint public totalEleitores = 1;

    // Salva o usuario criador do contrato
    address public criador;

    // Inicializa a eleicao com os candidatos
    constructor () public {
        criador = msg.sender;
        addCandidato("Candidato 1","Proposta do candidato 1");
        addCandidato("Candidato 2","Proposta do candidato 2");
        addCandidato("Candidato 3","Proposta do candidato 3");
    }

    event votedEvent (
        uint indexed _CandidatoId
    );

    function addEleitor(address _conta) private{
        //Garante que apenas o criador do contrato (eleicao) possa adicionar novos eleitores
        require(criador == msg.sender, "Somente o criador do contrato pode adicionar novos eleitores");

        // Cria um novo eleitor
        Eleitores[totalEleitores] = Eleitor(totalEleitores-1, _conta, false);

        // Adiciona 1 nos valores de id
        totalEleitores ++;
    }

    function addCandidato (string memory _name, string memory _proposta) private {
        //Garante que apenas o criador do contrato (eleicao) possa adicionar novos candidatos
        require(criador == msg.sender, "Somente o criador do contrato pode adicionar novos candidatos");

        // Cria um novo candidato
        Candidatos[totalCandidatos] = Candidato(totalCandidatos-1, _name, _proposta, 0);

        // Adiciona 1 nos valores de id
        totalCandidatos ++;
    }

    function vote (uint _CandidatoId) public {
        // Garante que a pessoa ainda não tenha votado
        // Caso ja tinha votado, ele sai da funcao
        require(!voters[msg.sender], "Você já votou");

        // Garante que o candidato exista
        // Caso o candidato nao exista, ele sai da funcao
        require(_CandidatoId > 0 && _CandidatoId <= totalCandidatos, "Candidato inexistente");

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

    function listaCandidatos() public view returns (){

    }
}