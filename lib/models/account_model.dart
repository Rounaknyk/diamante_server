import 'package:flutter/material.dart';

class AccountModel {
  final ParentJson parentJson;
  final ChildJson childJson;
  final String childPublicKey;
  final String pairPublicKey;
  final String pairSecretKey;

  AccountModel({
    required this.parentJson,
    required this.childJson,
    required this.childPublicKey,
    required this.pairPublicKey,
    required this.pairSecretKey,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      parentJson: ParentJson.fromJson(json['parentJson']),
      childJson: ChildJson.fromJson(json['childJson']),
      childPublicKey: json['childPublicKey'],
      pairPublicKey: json['pairPublicKey'],
      pairSecretKey: json['pairSecretKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parentJson': parentJson.toJson(),
      'childJson': childJson.toJson(),
      'childPublicKey': childPublicKey,
      'pairPublicKey': pairPublicKey,
      'pairSecretKey': pairSecretKey,
    };
  }
}

class ParentJson {
  final Links links;
  final String id;
  final String pagingToken;
  final bool successful;
  final String hash;
  final int ledger;
  final String createdAt;
  final String sourceAccount;
  final String sourceAccountSequence;
  final String feeAccount;
  final String feeCharged;
  final String maxFee;
  final int operationCount;
  final String envelopeXdr;
  final String resultXdr;
  final String resultMetaXdr;
  final String feeMetaXdr;
  final String memoType;
  final List<String> signatures;
  final String validAfter;

  ParentJson({
    required this.links,
    required this.id,
    required this.pagingToken,
    required this.successful,
    required this.hash,
    required this.ledger,
    required this.createdAt,
    required this.sourceAccount,
    required this.sourceAccountSequence,
    required this.feeAccount,
    required this.feeCharged,
    required this.maxFee,
    required this.operationCount,
    required this.envelopeXdr,
    required this.resultXdr,
    required this.resultMetaXdr,
    required this.feeMetaXdr,
    required this.memoType,
    required this.signatures,
    required this.validAfter,
  });

  factory ParentJson.fromJson(Map<String, dynamic> json) {
    return ParentJson(
      links: Links.fromJson(json['_links']),
      id: json['id'],
      pagingToken: json['paging_token'],
      successful: json['successful'],
      hash: json['hash'],
      ledger: json['ledger'],
      createdAt: json['created_at'],
      sourceAccount: json['source_account'],
      sourceAccountSequence: json['source_account_sequence'],
      feeAccount: json['fee_account'],
      feeCharged: json['fee_charged'],
      maxFee: json['max_fee'],
      operationCount: json['operation_count'],
      envelopeXdr: json['envelope_xdr'],
      resultXdr: json['result_xdr'],
      resultMetaXdr: json['result_meta_xdr'],
      feeMetaXdr: json['fee_meta_xdr'],
      memoType: json['memo_type'],
      signatures: List<String>.from(json['signatures']),
      validAfter: json['valid_after'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_links': links.toJson(),
      'id': id,
      'paging_token': pagingToken,
      'successful': successful,
      'hash': hash,
      'ledger': ledger,
      'created_at': createdAt,
      'source_account': sourceAccount,
      'source_account_sequence': sourceAccountSequence,
      'fee_account': feeAccount,
      'fee_charged': feeCharged,
      'max_fee': maxFee,
      'operation_count': operationCount,
      'envelope_xdr': envelopeXdr,
      'result_xdr': resultXdr,
      'result_meta_xdr': resultMetaXdr,
      'fee_meta_xdr': feeMetaXdr,
      'memo_type': memoType,
      'signatures': signatures,
      'valid_after': validAfter,
    };
  }
}

class ChildJson {
  final Links links;
  final String id;
  final String pagingToken;
  final bool successful;
  final String hash;
  final int ledger;
  final String createdAt;
  final String sourceAccount;
  final String sourceAccountSequence;
  final String feeAccount;
  final String feeCharged;
  final String maxFee;
  final int operationCount;
  final String envelopeXdr;
  final String resultXdr;
  final String resultMetaXdr;
  final String feeMetaXdr;
  final String memoType;
  final List<String> signatures;
  final String validAfter;
  final String validBefore;
  final dynamic offerResults;

  ChildJson({
    required this.links,
    required this.id,
    required this.pagingToken,
    required this.successful,
    required this.hash,
    required this.ledger,
    required this.createdAt,
    required this.sourceAccount,
    required this.sourceAccountSequence,
    required this.feeAccount,
    required this.feeCharged,
    required this.maxFee,
    required this.operationCount,
    required this.envelopeXdr,
    required this.resultXdr,
    required this.resultMetaXdr,
    required this.feeMetaXdr,
    required this.memoType,
    required this.signatures,
    required this.validAfter,
    required this.validBefore,
    this.offerResults,
  });

  factory ChildJson.fromJson(Map<String, dynamic> json) {
    return ChildJson(
      links: Links.fromJson(json['_links']),
      id: json['id'],
      pagingToken: json['paging_token'],
      successful: json['successful'],
      hash: json['hash'],
      ledger: json['ledger'],
      createdAt: json['created_at'],
      sourceAccount: json['source_account'],
      sourceAccountSequence: json['source_account_sequence'],
      feeAccount: json['fee_account'],
      feeCharged: json['fee_charged'],
      maxFee: json['max_fee'],
      operationCount: json['operation_count'],
      envelopeXdr: json['envelope_xdr'],
      resultXdr: json['result_xdr'],
      resultMetaXdr: json['result_meta_xdr'],
      feeMetaXdr: json['fee_meta_xdr'],
      memoType: json['memo_type'],
      signatures: List<String>.from(json['signatures']),
      validAfter: json['valid_after'],
      validBefore: json['valid_before'],
      offerResults: json['offerResults'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_links': links.toJson(),
      'id': id,
      'paging_token': pagingToken,
      'successful': successful,
      'hash': hash,
      'ledger': ledger,
      'created_at': createdAt,
      'source_account': sourceAccount,
      'source_account_sequence': sourceAccountSequence,
      'fee_account': feeAccount,
      'fee_charged': feeCharged,
      'max_fee': maxFee,
      'operation_count': operationCount,
      'envelope_xdr': envelopeXdr,
      'result_xdr': resultXdr,
      'result_meta_xdr': resultMetaXdr,
      'fee_meta_xdr': feeMetaXdr,
      'memo_type': memoType,
      'signatures': signatures,
      'valid_after': validAfter,
      'valid_before': validBefore,
      'offerResults': offerResults,
    };
  }
}

class Links {
  final Map<String, dynamic> self;
  final Map<String, dynamic> account;
  final Map<String, dynamic> ledger;
  final Map<String, dynamic> operations;
  final Map<String, dynamic> effects;
  final Map<String, dynamic> precedes;
  final Map<String, dynamic> succeeds;
  final Map<String, dynamic> transaction;

  Links({
    required this.self,
    required this.account,
    required this.ledger,
    required this.operations,
    required this.effects,
    required this.precedes,
    required this.succeeds,
    required this.transaction,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      self: json['self'],
      account: json['account'],
      ledger: json['ledger'],
      operations: json['operations'],
      effects: json['effects'],
      precedes: json['precedes'],
      succeeds: json['succeeds'],
      transaction: json['transaction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'self': self,
      'account': account,
      'ledger': ledger,
      'operations': operations,
      'effects': effects,
      'precedes': precedes,
      'succeeds': succeeds,
      'transaction': transaction,
    };
  }
}