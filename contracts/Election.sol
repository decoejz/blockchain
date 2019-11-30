pragma solidity >=0.4.2 <0.7.0;

//Referencia para o codigo:
//https://www.dappuniversity.com/articles/the-ultimate-ethereum-dapp-tutorial

//truffle migrate --reset
//truffle console
//Election.deployed().then(function(instance) { app = instance })
//app.Candidatos(1)
contract Election {
    
    // Adicionar candidato apenas o criador do contrato - OK
    // Garantir que haverá apenas um voto por eleitor - OK
    // Adicionar lista de eleitores - OK
    // Funcao que torna o vencedor - OK
    // Lista os candidatos em ordem de quantidade de votos

    // Modela um candidato
    struct Candidato {
        uint id;
        string nome;
        string proposta;
        uint contagem;
    }

    struct Eleitor {
        address conta;
        bool votou;
    }

    // Cria uma lista de candidatos
    mapping(uint => Candidato) public Candidatos;

    // Cria uma lista de eleitores
    mapping(address => Eleitor) public Eleitores;

    // Guarda o total de candidatos que tem em uma eleicao
    uint public totalCandidatos;

    // Guarda o total de candidatos que tem em uma eleicao
    uint public totalEleitores;

    // Salva o usuario criador do contrato
    address public criador;

    // Inicializa a eleicao com os candidatos
    constructor () public {
        criador = msg.sender;
        addCandidato("Candidato 1","Proposta do candidato 1");
        addCandidato("Candidato 2","Proposta do candidato 2");
        addCandidato("Candidato 3","Proposta do candidato 3");
        addEleitor(address(0x79BCe42e2497b063FDC47f97dF11c2fd8A2AAd75));
        addEleitor(address(0x5ce66Af146Bf02AaB10100C9f2BFfBB0b3626635));
    }

    event eventoVotacaoCandidato (
        uint indexed _CandidatoId
    );

    function addEleitor(address _conta) private{
        //Garante que apenas o criador do contrato (eleicao) possa adicionar novos eleitores
        require(criador == msg.sender, "Somente o criador do contrato pode adicionar novos eleitores");
        
        // Adiciona 1 nos valores de id
        totalEleitores ++;
        // Cria um novo eleitor
        Eleitores[_conta] = Eleitor(_conta, false);
    }

    function addCandidato (string memory _name, string memory _proposta) private {
        //Garante que apenas o criador do contrato (eleicao) possa adicionar novos candidatos
        require(criador == msg.sender, "Somente o criador do contrato pode adicionar novos candidatos");
        
        // Adiciona 1 nos valores de id
        totalCandidatos ++;
        // Cria um novo candidato
        Candidatos[totalCandidatos] = Candidato(totalCandidatos-1, _name, _proposta, 0);
    }

    function vote (uint _CandidatoId) public {
        // Garante que a pessoa ainda não votou
        // Caso ja tinha votado, ele sai da funcao
        require(!Eleitores[msg.sender].votou, "Você já votou");

        // Garante que o candidato exista
        // Caso o candidato nao exista, ele sai da funcao
        require(_CandidatoId > 0 && _CandidatoId <= totalCandidatos, "Candidato inexistente");

        // Muda o estado do eleitor dizendo que ele votou
        Eleitores[msg.sender].votou = true;

        // Atualiza a quantidade de votos de um candidato
        Candidatos[_CandidatoId].contagem = Candidatos[_CandidatoId].contagem + 1;

        // Libera o evento de que o candidato recebeu um voto
        emit eventoVotacaoCandidato(_CandidatoId);
    }

    function visualizaVotosCandidato(uint _CandidatoId) public view returns (uint votos) {
        // Retorna a quantidade de votos de um dado candidato
        return Candidatos[_CandidatoId].contagem;
    }

    function vencedor() public view returns (string memory nome, uint totalVotos){
        // Retorna o nome e a quantidade de votos do vencedor da eleicao
        totalVotos = 0;
        for (uint p = 0; p < totalCandidatos; p++) {
            if (Candidatos[p].contagem > totalVotos) {
                totalVotos = Candidatos[p].contagem;
                nome = Candidatos[p].nome;
            }
        }
    }

    function visualizaEleitorVotou(address _conta) public view returns (bool votou) {
        // Retorna se um dado eleitor votou ou nao
        return Eleitores[_conta].votou;
    }

    // function listaCandidatos() public view returns (Candidato[] memory){
    //     Candidato[] memory ordemVencedores = new Candidato[](totalCandidatos);
        
    //     // FAZER ALGORITMO DE SORTING
    //     // for (uint i = 0; i < totalCandidatos; i++) {
    //     //     for (uint j = 0; j < totalCandidatos; j++) {
    //     //         if (Candidatos[i].contagem > ordemVencedores[j].contagem) {
    //     //             Candidato temp = ordemVencedores[j];
    //     //             ordemVencedores[j] = Candidatos[i];

    //     //         }
    //     //     }
    //     // } 

    //     return (ordemVencedores);
    // }
}