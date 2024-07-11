

# ChainMaker 源码解读



## 1、长安链源码：

````
func VerifyBlockSignatures(chainConf protocol.ChainConf, ac protocol.AccessControlProvider,
	store protocol.BlockchainStore, block *commonpb.Block, ledger protocol.LedgerCache) error {
	consensusType := chainConf.ChainConfig().Consensus.Type
	switch consensusType {
	case consensuspb.ConsensusType_TBFT:
		// get validator list by module of tbft
		return tbft.VerifyBlockSignatures(chainConf, ac, block, store, tbft.GetValidatorList)
	case consensuspb.ConsensusType_DPOS:
		// get validator list by module of dpos
		return tbft.VerifyBlockSignatures(chainConf, ac, block, store, dpos.GetValidatorList)
	case consensuspb.ConsensusType_RAFT:
		return raft.VerifyBlockSignatures(block)
	case consensuspb.ConsensusType_MAXBFT:
		return maxbft.VerifyBlockSignatures(chainConf, ac, store, block, ledger)
	case consensuspb.ConsensusType_SOLO:
		return nil
		//for rebuild-dbs
	default:
	}
	return fmt.Errorf("error consensusType: %s", consensusType)
}

````



## 交易类型

```
const (
	// call a pre created contract, tx included in block
	TxType_INVOKE_CONTRACT TxType = 0
	// query a pre-created  contract, tx not included in block
	TxType_QUERY_CONTRACT TxType = 1
	// subscribe block info,tx info and contract info. tx not included in block
	TxType_SUBSCRIBE TxType = 2
	// archive/restore block, tx not included in block
	TxType_ARCHIVE TxType = 3
	// ethereum tx flag: >0xF, default legacy eth tx
	TxType_ETH_TX TxType = 16
	// separate hot and cold data
	TxType_HOT_COLD_DATA_SEPARATION TxType = 4
	// snapshot
	TxType_SNAPSHOT TxType = 5
)


var TxType_name = map[int32]string{
	0:  "INVOKE_CONTRACT",
	1:  "QUERY_CONTRACT",
	2:  "SUBSCRIBE",
	3:  "ARCHIVE",
	16: "ETH_TX",
	4:  "HOT_COLD_DATA_SEPARATION",
	5:  "SNAPSHOT",
}

var TxType_value = map[string]int32{
	"INVOKE_CONTRACT":          0,
	"QUERY_CONTRACT":           1,
	"SUBSCRIBE":                2,
	"ARCHIVE":                  3,
	"ETH_TX":                   16,
	"HOT_COLD_DATA_SEPARATION": 4,
	"SNAPSHOT":                 5,
}
```



### Sys_contract

```
#   chainmake.org/chainmaker/pb-go/v3@v3.0.1   syscontract/system_contract.pb.go

var SystemContract_name = map[int32]string{
	0:  "CHAIN_CONFIG",
	1:  "CHAIN_QUERY",
	2:  "CERT_MANAGE",
	3:  "GOVERNANCE",
	4:  "MULTI_SIGN",
	5:  "CONTRACT_MANAGE",
	6:  "PRIVATE_COMPUTE",
	7:  "DPOS_ERC20",
	8:  "DPOS_STAKE",
	9:  "SUBSCRIBE_MANAGE",
	10: "ARCHIVE_MANAGE",
	11: "CROSS_TRANSACTION",
	12: "PUBKEY_MANAGE",
	13: "ACCOUNT_MANAGER",
	14: "DPOS_DISTRIBUTION",
	15: "DPOS_SLASHING",
	16: "COINBASE",
	17: "RELAY_CROSS",
	18: "TRANSACTION_MANAGER",
	19: "SNAPSHOT_MANAGE",
	20: "HOT_COLD_DATA_SEPARATE_MANAGE",
	21: "ETHEREUM",
	99: "T",
}


```





















## 2、管理后端

### 2.1 系统表：

```
# location: src/db/common/table.go
# package common

const (
	TableBlock          = "cmb_block"
	TableChain          = "cmb_chain"
	TableTransaction    = "cmb_transaction"
	TableCert           = "cmb_cert"
	TableNode           = "cmb_node"
	TableOrg            = "cmb_org"
	TableContract       = "cmb_contract"
	TableInvokeRecords  = "cmb_invoke_records"
	TableChainPolicy    = "cmb_chain_policy"
	TableChainPolicyOrg = "cmb_chain_policy_org"
	TableChainOrg       = "cmb_chain_org"
	TableChainOrgNode   = "cmb_chain_org_node"
	TableChainUser      = "cmb_chain_user"
	TableOrgNode        = "cmb_org_node"
	TableUploadContent  = "cmb_upload_content"
	TableUser           = "cmb_user"
	TableVoteManagement = "cmb_vote_management"
	TableChainConfig    = "cmb_chain_config"
	TableChainErrorLog  = "cmb_chain_error_log"
	TableChainSubscribe = "cmb_chain_subscribe"
)

```



### 2.2 系统合约

```
# location: src/db/entity/request.go
# package entity

// 合约管理

	InstallContract       = "InstallContract"
	FreezeContract        = "FreezeContract"
	UnFreezeContract      = "UnFreezeContract"
	RevokeContract        = "RevokeContract"
	UpgradeContract       = "UpgradeContract"
	GetRuntimeTypeList    = "GetRuntimeTypeList"
	GetContractManageList = "GetContractManageList"
	ContractDetail        = "ContractDetail"
	ModifyContract        = "ModifyContract"
	GetInvokeContractList = "GetInvokeContractList"
	InvokeContract        = "InvokeContract"
	ReInvokeContract      = "ReInvokeContract"
	GetInvokeRecordList   = "GetInvokeRecordList"
	GetInvokeRecordDetail = "GetInvokeRecordDetail"
	DeleteContract        = "DeleteContract"


```



### 2.2 删表

```

func DeleteChain(chainId string) error {
	tx := connection.DB.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()
	if err := tx.Error; err != nil {
		return err
	}
	// handle chain

	if err := tx.Debug().Where("chain_id = ?", chainId).Delete(&common.Chain{}).Error; err != nil {
		tx.Rollback()
		return err
	}

	// handle chainOrg
	if err := tx.Debug().Where("chain_id = ?", chainId).Delete(&common.ChainOrg{}).Error; err != nil {
		tx.Rollback()
		return err
	}

	// handle chainOrgNode
	if err := tx.Debug().Where("chain_id = ?", chainId).Delete(&common.ChainOrgNode{}).Error; err != nil {
		tx.Rollback()
		return err
	}

	// handle chainAdmin
	if err := tx.Debug().Where("chain_id = ?", chainId).Delete(&common.ChainUser{}).Error; err != nil {
		tx.Rollback()
		return err
	}

	// handle chainSub
	if err := tx.Debug().Where("chain_id = ?", chainId).Delete(&common.ChainSubscribe{}).Error; err != nil {
		tx.Rollback()
		return err
	}

	go func() {
		// handle chainConfig
		if err := connection.DB.Where("chain_id = ?", chainId).Delete(&common.ChainConfig{}).Error; err != nil {
			log.Error(err)
		}
		// handle chainPolicyOrg
		if err := connection.DB.Where("chain_id = ?", chainId).Delete(&common.ChainPolicyOrg{}).Error; err != nil {
			log.Error(err)
		}
		// handle chainPolicy
		if err := connection.DB.Where("chain_id = ?", chainId).Delete(&common.ChainPolicy{}).Error; err != nil {
			log.Error(err)
		}
		// handle chainContract
		if err := connection.DB.Where("chain_id = ?", chainId).Delete(&common.Contract{}).Error; err != nil {
			log.Error(err)
		}
		// handle chainTx
		if err := connection.DB.Where("chain_id = ?", chainId).Delete(&common.Transaction{}).Error; err != nil {
			log.Error(err)
		}
		// handle chainBlock
		if err := connection.DB.Where("chain_id = ?", chainId).Delete(&common.Block{}).Error; err != nil {
			log.Error(err)
		}
		// handle chainVote
		if err := connection.DB.Where("chain_id = ?", chainId).Delete(&common.VoteManagement{}).Error; err != nil {
			log.Error(err)
		}
		// handle chainInvoke
		if err := connection.DB.Where("chain_id = ?", chainId).Delete(&common.InvokeRecords{}).Error; err != nil {
			log.Error(err)
		}
	}()

	return tx.Commit().Error
}



```



