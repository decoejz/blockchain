pragma solidity >=0.4.2 <0.7.0;

// Referencia para o codigo:
// https://www.dappuniversity.com/articles/the-ultimate-ethereum-dapp-tutorial
// https://ethereum.stackexchange.com/questions/65589/return-a-mapping-in-a-getall-function

//truffle migrate --reset
//truffle console
//Election.deployed().then(function(instance) { app = instance })
//app.Candidatos(1)
contract Election {
    
    // Apenas o criador do contrato pode adicionar um candidato
    // Apenas o criador do contrato pode adicionar um eleitor
    // Adicionar um voto
    // Apenas um voto por eleitor
    // Listar os candidatos
    // Retorna o vencedor
    // Visualiza se um eleitor especifico ja votou ou nao

    // Modela um candidato
    struct Candidato {
        uint id;
        address conta;
        string nome;
        string proposta;
        uint contagem;
    }

    struct Eleitor {
        uint id;
        address conta;
        bool votou;
    }

    // Cria uma lista de candidatos
    mapping(uint => Candidato) public Candidatos;

    // Cria uma lista de eleitores
    mapping(address => Eleitor) public Eleitores;

    // Guarda o total de candidatos que tem em uma eleicao
    uint public totalCandidatos = 0;

    // Guarda o total de candidatos que tem em uma eleicao
    uint public totalEleitores = 0;

    // Salva o usuario criador do contrato
    address public criador;

    // Inicializa a eleicao com os candidatos
    constructor () public {
        criador = msg.sender;
        addCandidato("Manoela","Mais Cloud",address(0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c));
        addCandidato("Wesley","Mais Raspberry Pi",address(0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C));
        addCandidato("David","Mais Node / React",address(0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB));
        addEleitor(address(0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c));
        addEleitor(address(0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C));
        addEleitor(address(0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB));
        addEleitor(address(0x583031D1113aD414F02576BD6afaBfb302140225));
        addEleitor(address(0xdD870fA1b7C4700F2BD7f44238821C26f7392148));
    }

    event eventoVotacaoCandidato (
        uint indexed _CandidatoId
    );

    function addEleitor(address _conta) private {
        //Garante que apenas o criador do contrato (eleicao) possa adicionar novos eleitores
        require(criador == msg.sender, "Somente o criador do contrato pode adicionar novos eleitores");
        
        // Adiciona 1 nos valores de id
        totalEleitores ++;
        // Cria um novo eleitor
        Eleitores[_conta] = Eleitor(totalEleitores, _conta, false);
    }

    function addCandidato (string memory _name, string memory _proposta, address _conta) private {
        //Garante que apenas o criador do contrato (eleicao) possa adicionar novos candidatos
        require(criador == msg.sender, "Somente o criador do contrato pode adicionar novos candidatos");
        
        // Adiciona 1 nos valores de id
        totalCandidatos ++;
        // Cria um novo candidato
        Candidatos[totalCandidatos] = Candidato(totalCandidatos-1, _conta, _name, _proposta, 0);
    }

    function vote (uint _CandidatoId) public {
        // Garante que o eleitor esta na lista de eleitores
        require(Eleitores[msg.sender].id > 0 && Eleitores[msg.sender].id <= totalEleitores, "Você não tem direito de votar");

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
        for (uint p = 1; p <= totalCandidatos; p++) {
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

    function todosCandidatos() public view returns (address[] memory){
        // Retorna uma lista com todos os ids de 
        address[] memory ret = new address[](totalCandidatos);
        for (uint i = 0; i < totalCandidatos; i++) {
            ret[i] = Candidatos[i+1].conta;
        }
        return ret;
    }
}
