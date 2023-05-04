use kyc;
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE `kyc_operations`;
INSERT INTO `kyc_operations` (`id`, `initial_state_id`, `code`, `name`, `description`, `criteria`)
VALUES
	(1, 2, 'ADD_KYC', 'ADD KYC', 'Add Kyc for first time', NULL),
	(2, NULL, 'UPDATE_KYC', 'UPDATE KYC', 'UPDATE KYC details', NULL),
	(3, 8, 'VALIDATE_KYC', 'VALIDATE_KYC', 'VALIDATE_KYC', NULL),
	(4, NULL, 'APPROVE_KYC', 'APPROVE_KYC', 'APPROVE_KYC', NULL),
	(5, NULL, 'REJECT_KYC', 'REJECT_KYC', 'REJECT_KYC', NULL),
	(6, 1, 'OFFLINE_KYC', 'OFFLINE_KYC', 'OFFLINE_KYC', NULL),
	(7, NULL, 'ONLINE_SYNC_KYC', 'ONLINE_SYNC_KYC', 'ONLINE_SYNC_KYC', NULL),
	(8, NULL, 'GRACE_CHECK', 'GRACE_CHECK', 'This is grace check exceeded operation', NULL),
	(9, 2, 'SELF_ADD_KYC', 'SELF_ADD_KYC', 'This is self add kyc operation', NULL);

TRUNCATE TABLE `kyc_states`;
INSERT INTO `kyc_states` (`id`, `code`, `name`, `description`, `available_from`, `available_until`)
VALUES
	(1, 'OFFLINE_PENDING_APPROVAL', 'OFFLINE PENDING APPROVAL', 'initial state for offline kyc', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(2, 'PENDING_APPROVAL', 'PENDING APPROVAL', 'initial state for online kyc', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(3, 'PRE_APPROVED', 'PRE APPROVED', 'pre-approval by back-office', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(4, 'APPROVED', 'APPROVED', 'kyc Approved', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(5, 'REJECTED', 'REJECTED', 'kyc rejected', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(6, 'EXPIRED', 'EXPIRED', 'new kyc for re-cycled product/account then expire previous record', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(7, 'GRACE_PERIOD_EXCEEDED', 'GRACE_PERIOD_EXCEEDED', 'This state is for Grace_Check operation.', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(8, 'VALIDATE', 'VALIDATE', 'This state is for validate operation.', '2021-02-09 16:58:27', '2099-01-01 00:00:00'),
	(9, 'SEMI_PRE_APPROVED', 'SEMI_PRE_APPROVED', 'pre-approval by back-office', '2021-02-09 16:58:27', '2099-01-01 00:00:00');

TRUNCATE TABLE `kyc_state_transitions`;
INSERT INTO `kyc_state_transitions` (`id`, `from_state_id`, `operation_id`, `to_state_id`, `business_rules`, `mandatory_business_actions`, `business_actions`, `available_from`, `available_until`)
VALUES
	(1, 2, 1, 4, NULL, 'DMSAction', NULL, '2021-02-09 18:16:07', NULL),
	(2, 2, 2, 2, NULL, NULL, 'FetchAsmAction', '2021-02-09 18:16:07', NULL),
	(3, 2, 4, 4, NULL, NULL, 'DMSAction', '2021-02-09 18:16:07', NULL),
	(4, 2, 5, 5, NULL, NULL, NULL, '2021-09-01 18:16:07', NULL),
	(5, 2, 5, 5, NULL, NULL, 'DealerStatusRejectAction', '2021-02-09 18:16:07', NULL),
	(6, 2, 1, 2, NULL, 'DMSAction', 'FetchAsmAction', '2021-02-09 18:16:07', NULL),
	(7, 2, 1, 2, NULL, 'DMSAction', 'FetchAsmAction', '2021-02-09 18:16:07', NULL),
    (8, 2, 2, 2, NULL, NULL, NULL, '2021-02-09 18:16:07', NULL),
    (9, 4, 2, 4, NULL, NULL, NULL, '2023-02-06 10:40:48', NULL);

TRUNCATE TABLE `kyc_state_transition_permissions`;
INSERT INTO `kyc_state_transition_permissions` (`id`, `state_transition_id`, `reseller_type`, `role_id`, `criteria`)
VALUES
	(1, 1, 'Operator', NULL, NULL),
	(2, 1, 'POS', NULL, NULL),
	(3, 1, 'Distributor', NULL, '<#if kycTransaction.customer.customerType=\"SubDistributor\">2</#if>'),
	(4, 1, 'FranchiseShop', NULL, NULL),
	(5, 1, 'Bank', NULL, NULL),
	(6, 1, 'Warehouse', NULL, NULL),
	(7, 1, 'ASM', NULL, ''),
	(8, 1, 'OperatorAgent', NULL, NULL),
	(9, 1, 'Agent', NULL, '<#if kycTransaction.customer.customerType=\"POS\">6</#if>'),
	(10, 1, 'SubDistributor', NULL, '<#if kycTransaction.customer.customerType=\"Agent\">2</#if>'),
	(11, 2, 'ASM', NULL, NULL),
	(12, 4, 'ASM', NULL, '<#if kycTransaction.customer.customerType=\"POS\">5</#if>'),
	(14, 3, 'ASM', NULL, NULL),
    (15, 8, 'Operator', NULL, NULL),
    (16, 9, 'Operator', NULL, NULL);

TRUNCATE TABLE `kyc_templates`;
INSERT INTO `kyc_templates` (`template_name`, `template_value`)
VALUES
	('Direct_sales', '{\n\"problems\": [{\n    \"Diabetes\":[{\n        \"medications\":[{\n            \"medicationsClasses\":[{\n                \"className\":[{\n                    \"associatedDrug\":[{\n                        \"name\":\"asprin\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }],\n                    \"associatedDrug#2\":[{\n                        \"name\":\"somethingElse\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }]\n                }],\n                \"className2\":[{\n                    \"associatedDrug\":[{\n                        \"name\":\"asprin\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }],\n                    \"associatedDrug#2\":[{\n                        \"name\":\"somethingElse\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }]\n                }]\n            }]\n        }],\n        \"labs\":[{\n            \"missing_field\": \"missing_value\"\n        }]\n    }],\n    \"Asthma\":[{}]\n}]}'),
	('Indirect_sales', '{\n\"problems\": [{\n    \"Diabetes\":[{\n        \"medications\":[{\n            \"medicationsClasses\":[{\n                \"className\":[{\n                    \"associatedDrug\":[{\n                        \"name\":\"asprin\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }],\n                    \"associatedDrug#2\":[{\n                        \"name\":\"somethingElse\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }]\n                }],\n                \"className2\":[{\n                    \"associatedDrug\":[{\n                        \"name\":\"asprin\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }],\n                    \"associatedDrug#2\":[{\n                        \"name\":\"somethingElse\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }]\n                }]\n            }]\n        }],\n        \"labs\":[{\n            \"missing_field\": \"missing_value\"\n        }]\n    }],\n    \"Asthma\":[{}]\n}]}'),
	('Direct_distributor', '{\n\"problems\": [{\n    \"Diabetes\":[{\n        \"medications\":[{\n            \"medicationsClasses\":[{\n                \"className\":[{\n                    \"associatedDrug\":[{\n                        \"name\":\"asprin\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }],\n                    \"associatedDrug#2\":[{\n                        \"name\":\"somethingElse\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }]\n                }],\n                \"className2\":[{\n                    \"associatedDrug\":[{\n                        \"name\":\"asprin\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }],\n                    \"associatedDrug#2\":[{\n                        \"name\":\"somethingElse\",\n                        \"dose\":\"\",\n                        \"strength\":\"500 mg\"\n                    }]\n                }]\n            }]\n        }],\n        \"labs\":[{\n            \"missing_field\": \"missing_value\"\n        }]\n    }],\n    \"Asthma\":[{}]\n}]}');

SET FOREIGN_KEY_CHECKS = 1;
