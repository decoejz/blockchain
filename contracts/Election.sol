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
        addCandidato("Manoela","Mais Cloud",address(0xf9Ff6C8fBDf4bed17C5c2E4504e22fCe3225F1eD));
        addCandidato("Wesley","Mais Raspberry Pi",address(0x20d686Cb5b4e282614BC08E02917E2fba6d32296));
        addCandidato("David","Mais Node / React",address(0xA1DaBAe16616526F08E921FB1D03C2814De32b68));
        addEleitor(address(0x617DeD1392499354fD091F1F2c6Eb71e8b937CbC));
        addEleitor(address(0xe76B54d33B9F6f2f35e51708c0C94511CEaC9098));
        addEleitor(address(0x35E55be62Bd30be203090DfA12F26490e55Ec779));
        addEleitor(address(0xf9Ff6C8fBDf4bed17C5c2E4504e22fCe3225F1eD));
        addEleitor(address(0x20d686Cb5b4e282614BC08E02917E2fba6d32296));
    }

    event eventoVotacaoCandidato (
        uint indexed _CandidatoId
    );

    function addEleitor(address _conta) private {
        //Garante que apenas o criador do contrato (eleicao) possa adicionar novos eleitores
        require(criador == msg.sender, "Somente o criador do contrato pode adicionar novos eleitores");
        
        // Cria um novo eleitor
        Eleitores[_conta] = Eleitor(totalEleitores, _conta, false);
        // Adiciona 1 nos valores de id
        totalEleitores ++;
    }

    function addCandidato (string memory _name, string memory _proposta, address _conta) private {
        //Garante que apenas o criador do contrato (eleicao) possa adicionar novos candidatos
        require(criador == msg.sender, "Somente o criador do contrato pode adicionar novos candidatos");
        
        // Cria um novo candidato
        Candidatos[totalCandidatos] = Candidato(totalCandidatos-1, _conta, _name, _proposta, 0);
        // Adiciona 1 nos valores de id
        totalCandidatos ++;
    }

    function vote (uint _CandidatoId) public {
        // Garante que o eleitor esta na lista de eleitores
        require(Eleitores[msg.sender].id >= 0 && Eleitores[msg.sender].id < totalEleitores, "Você não tem direito de votar");

        // Garante que a pessoa ainda não votou
        // Caso ja tinha votado, ele sai da funcao
        require(!Eleitores[msg.sender].votou, "Você já votou");

        // Garante que o candidato exista
        // Caso o candidato nao exista, ele sai da funcao
        require(_CandidatoId >= 0 && _CandidatoId < totalCandidatos, "Candidato inexistente");

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

    function todosCandidatos() public view returns (address[] memory){
        // Retorna uma lista com todos os ids de 
        address[] memory ret = new address[](totalCandidatos);
        for (uint i = 0; i < totalCandidatos; i++) {
            ret[i] = Candidatos[i].conta;
        }
        return ret;
    }
}
