<template>
  <div id="treasure">
    <ae-amount-input :value="inputValue" symbol="ETH" :step="0.01" @input='changeInput'></ae-amount-input>
    <div>
      <input type="text" v-model="inputPassword"></input>
    </div>
    <div v-if="inputPassword">
      <ae-button @click="addTreasure()" type="plain" size="small">Hide Treasure</ae-button>
    </div>
    <div v-if="inputPassword">
      <ae-button @click="increaseBounty()" type="plain" size="small">Increase Bounty</ae-button>
    </div>
    <div v-if="inputPassword">
      <ae-button @click="claimTreasure()" type="plain" size="small">Dig up Treasure</ae-button>
    </div>
    <div v-if="inputPassword">
      <ae-button @click="getTreasure()" type="plain" size="small">See Treasure Info</ae-button>
    </div>
    <div v-if="myPayments > 0">
      <ae-button @click="withdrawPayments()" type="plain" size="small">Get my Bounty</ae-button>
    </div>
    <div>
      <span>Contract Balance: {{readableBalance}}</span>
    </div>
    <div>
      <span>Total claimed Bounties: {{readableTotalPayments}}</span>
    </div>
    <div>
      <span>My Bounties: {{readableMyPayments}}</span>
    </div>
  </div>
</template>

<script>
import { AeAmountInput, AeButton, AeAmount } from '@aeternity/aepp-components'
import TreasureContract from '../../dapp-scratch-wrapper/TreasureContract'
import Web3 from 'web3'
var crypto = require('crypto');
let treasureContract = new TreasureContract()
treasureContract.helloWorld()

export default {
  name: 'app',
  components: {
    AeAmountInput,
    AeButton,
    AeAmount
  },
  data () {
    return {
      inputValue: 0.01,
      inputPassword: '',
      inputPasswordSha: '',
      totalPayments: 0,
      myPayments: 0,
      contractBalance: 0
    }
  },
  computed: {
    readableBalance () {
      return this.readableEther(this.contractBalance)
    },
    readableMyPayments () {
      return this.readableEther(this.myPayments)
    },
    readableTotalPayments () {
      return this.readableEther(this.totalPayments)
    }
  },
  methods: {
    async addTreasure () {
      let password = this.inputPassword;
      let passwordSha = this.createHash(password);
      passwordSha = '0x' + passwordSha;
      let value = Web3.utils.toWei(this.inputValue.toString(), 'ether');
      let result = await treasureContract.addTreasure(passwordSha, value);
    },
    async increaseBounty () {
      let password = this.inputPassword;
      let passwordSha = this.createHash(password);
      passwordSha = '0x' + passwordSha;
      let value = Web3.utils.toWei(this.inputValue.toString(), 'ether');
      let result = await treasureContract.increaseBounty(passwordSha, value);
    },
    async claimTreasure () {
      let passwordSha = this.inputPassword;
      let result = await treasureContract.claimTreasure(passwordSha);
    },
    async getTreasure () {
      let password = this.inputPassword;
      let passwordSha = this.createHash(password);
      passwordSha = '0x' + passwordSha;
      passwordSha = Web3.utils.toHex(passwordSha)
      let result = await treasureContract.getTreasureByHash(passwordSha);
    },
    createHash (input) {
      return crypto.createHash('sha256').update(input).digest('hex');
    },
    async updateTotalPayments () {
      let result = await treasureContract.totalPayments();
      this.totalPayments = result;
    },
    async withdrawPayments () {
      let result = await treasureContract.withdrawPayments();
    },
    async updateContractBalance () {
      let result = await treasureContract.contractBalance();
      this.contractBalance = result;
    },
    changeInput (newValue) {
      this.inputValue = newValue;
    },
    readableEther (rawValue) {
      return Web3.utils.fromWei(rawValue.toString(), 'ether');
    },
    async getMyPayments () {
      let result = await treasureContract.paymentsByAddress();
      this.myPayments = result;
    },
    async updateBalances () {
      if (treasureContract.TreasureContract !== null) {
        this.getMyPayments();
        this.updateContractBalance();
        this.updateTotalPayments();
      }
    }
  },
  mounted: function() {
    this.updateBalances();
    setInterval(() => {
      this.updateBalances();
    }, 1000);
  }
}
</script>

<style>
body {
  background-color: white;
}
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
