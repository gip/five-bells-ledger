'use strict'

const TABLE_NAME = 'L_TRANSFERS'
const _ = require('lodash')
const db = require('./utils')(TABLE_NAME,
  convertToPersistent, convertFromPersistent)
const withTransaction = require('../../lib/db').withTransaction
const rejectionReasons = require('./rejectionReasons')
const transferStatuses = require('./transferStatuses')
const adjustments = require('./adjustments')

function convertFromPersistent (data) {
  data = _.cloneDeep(data)
  data = _.mapKeys(data, (value, key) => key.toLowerCase())
  data.id = data.transfer_id
  delete data.transfer_id
  delete data.created_at
  delete data.updated_at
  data.additional_info = JSON.parse(data.additional_info)
  if (data.expires_at) {
    data.expires_at = new Date(data.expires_at)
  }
  if (data.proposed_at) {
    data.proposed_at = new Date(data.proposed_at)
  }
  if (data.prepared_at) {
    data.prepared_at = new Date(data.prepared_at)
  }
  if (data.executed_at) {
    data.executed_at = new Date(data.executed_at)
  }
  if (data.rejected_at) {
    data.rejected_at = new Date(data.rejected_at)
  }
  if (data.rejection_reason_id !== null) {
    data.rejection_reason = rejectionReasons.getRejectionReasonName(
      data.rejection_reason_id)
    delete data.rejection_reason_id
  }
  data.state = transferStatuses.getTransferStatusName(data.status_id)
  delete data.status_id
  data = _.omit(data, _.isNull)
  return data
}

function convertToPersistent (data) {
  data = _.cloneDeep(data)
  delete data.credits
  delete data.debits
  data.additional_info = JSON.stringify(data.additional_info)
  if (data.proposed_at) {
    data.proposed_at = new Date(data.proposed_at)
  }
  if (data.prepared_at) {
    data.prepared_at = new Date(data.prepared_at)
  }
  if (data.executed_at) {
    data.executed_at = new Date(data.executed_at)
  }
  if (data.rejected_at) {
    data.rejected_at = new Date(data.rejected_at)
  }
  if (data.rejection_reason) {
    data.rejection_reason_id = rejectionReasons.getRejectionReasonId(
      data.rejection_reason)
    delete data.rejection_reason
  }
  if (data.state) {
    data.status_id = transferStatuses.getTransferStatusId(data.state)
    delete data.state
  }
  data.transfer_id = data.id
  delete data.id
  return _.mapKeys(data, (value, key) => key.toUpperCase())
}

function * getTransfer (id, options) {
  return db.selectOne({TRANSFER_ID: id}, options && options.transaction)
    .then((transfer) => {
      return adjustments.getAdjustments(id, options).then((adjustments) => {
        const result = _.assign({}, transfer, adjustments)
        return _.isEmpty(result) ? null : result
      })
    })
}

function * updateTransfer (transfer, options) {
  return db.update(transfer, {TRANSFER_ID: transfer.id},
    options && options.transaction).then((result) => {
      return adjustments.upsertAdjustments(transfer, options).then(() => result)
    })
}

function * insertTransfers (transfers, options) {
  return db.insertAll(transfers, options && options.transaction)
    .then(() => {
      return Promise.all(transfers.map((transfer) => {
        return adjustments.insertAdjustments(transfer, options)
      }))
    })
}

function * upsertTransfer (transfer, options) {
  return db.upsert(transfer, {TRANSFER_ID: transfer.id},
    options && options.transaction).then((result) => {
      return adjustments.upsertAdjustments(transfer, options).then(() => result)
    })
}

module.exports = {
  getTransfer,
  upsertTransfer,
  updateTransfer,
  insertTransfers,
  withTransaction,
  client: db.client
}
