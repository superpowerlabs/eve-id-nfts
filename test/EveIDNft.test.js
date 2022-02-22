const {expect, assert} = require("chai")

const {initEthers, assertThrowsMessage, signPackedData, getTimestamp, getBlockNumber, increaseBlockTimestampBy} = require('./helpers')

// tests to be fixed

describe("EveIDNft", function () {

  let EveIDNft
  let nft
  let nftAddress

  let addr0 = '0x0000000000000000000000000000000000000000'
  let owner,
      operator,
      validator,
      buyer1, buyer2,
      member1, member2, member3, member4, member5, member6,
      collector1, collector2

  before(async function () {
    ;[
      owner,
      operator,
      buyer1, buyer2,
      validator,
      member1, member2, member3, member4, member5, member6,
      collector1, collector2
    ] = await ethers.getSigners()
    EveIDNft = await ethers.getContractFactory("EveIDNft")
    initEthers(ethers)
  })

  async function initAndDeploy() {
    nft = await EveIDNft.deploy(
        "Eve ID Nft",
        "EVE",
        validator.address,
        "https://nft.eve.id/meta/"
    )
    await nft.deployed()
    nftAddress = nft.address
    await nft.setOperator(operator.address)
  }

  async function configure() {
  }

  describe('constructor and initialization', async function () {

    beforeEach(async function () {
      await initAndDeploy()
    })

    it("should return the EveIDNft address", async function () {
      await expect(await nft.validator()).to.equal(validator.address)
    })
  })

  describe('#claimFreeToken', async function () {

    beforeEach(async function () {
      await initAndDeploy()
    })

    it("should member1 mint a free token", async function () {

      const authCode = ethers.utils.id('a' + Math.random())

      const hash = await nft.encodeForSignature(member1.address, authCode, 0)
      const signature = await signPackedData(hash)

      await expect(await nft.connect(member1).claimFreeToken(authCode, 0, signature))
          .to.emit(nft, 'Transfer')
          .withArgs(addr0, member1.address, 9)

      assert.equal(await nft.usedCodes(authCode), member1.address)

      const remaining = await nft.getRemaining(0)
      assert.equal(remaining, 199)

    })

    it("should throw trying to mint 2 token same wallet", async function () {

      let authCode = ethers.utils.id('a' + Math.random())

      let hash = await nft.encodeForSignature(member1.address, authCode, 0)
      let signature = await signPackedData(hash)

      await nft.connect(member1).claimFreeToken(authCode, 0, signature)

      authCode = ethers.utils.id('b' + Math.random())
      hash = await nft.encodeForSignature(member1.address, authCode, 0)
      signature = await signPackedData(hash)

      await assertThrowsMessage(
          nft.connect(member1).claimFreeToken(authCode, 0, signature),
          'one pass per wallet'
      )

    })

    it("should throw trying to reuse same code", async function () {

      let authCode = ethers.utils.id('a' + Math.random())

      let hash = await nft.encodeForSignature(member1.address, authCode, 0)
      let signature = await signPackedData(hash)

      await nft.connect(member1).claimFreeToken(authCode, 0, signature)

      await assertThrowsMessage(
          nft.connect(member1).claimFreeToken(authCode, 0, signature),
          'authCode already used'
      )

    })

  })

  describe('#giveawayToken', async function () {

    beforeEach(async function () {
      await initAndDeploy()
    })

    it("should give a token to communityMember1", async function () {

      const authCode = ethers.utils.id('a' + Math.random())

      const hash = await nft.encodeForSignature(member1.address, authCode, 4)
      const signature = await signPackedData(hash)

      await expect(await nft.connect(operator).giveawayToken(member1.address, authCode, signature))
          .to.emit(nft, 'Transfer')
          .withArgs(addr0, member1.address, 9)

      assert.equal(await nft.usedCodes(authCode), member1.address)

      const remaining = await nft.getRemaining(4)
      assert.equal(remaining, 79)

    })

  })


})
