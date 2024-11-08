﻿INSERT INTO Domain (ID, Title, IsMultiValue, EnumValue, DataType) VALUES ('1E7A0001-6E2C-4F74-8966-A65601087EBF','Contact Information', 0, NULL, 'group')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('2F0A0001-AA11-4A76-A174-A65601234ABD', '1E7A0001-6E2C-4F74-8966-A65601087EBF', 0)-- associate Domain definition with Organizations
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('40330001-FBF6-490D-8746-A65601235227', '1E7A0001-6E2C-4F74-8966-A65601087EBF', 2)-- associate Domain definition with DataSources

INSERT INTO Domain (ID, ParentDomainID, Title, IsMultiValue, EnumValue, DataType) VALUES ('14930001-729F-4A3A-8509-A65601089365', '1E7A0001-6E2C-4F74-8966-A65601087EBF','First Name', 0, NULL, 'string')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('82790001-6318-423F-B1BF-A65601238941', '14930001-729F-4A3A-8509-A65601089365', 0)
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('E1EE0001-9417-48EC-A8C4-A65601238D61', '14930001-729F-4A3A-8509-A65601089365', 2)
INSERT INTO Domain (ID, ParentDomainID, Title, IsMultiValue, EnumValue, DataType) VALUES ('2F630001-06EF-483B-850B-A65601089B03', '1E7A0001-6E2C-4F74-8966-A65601087EBF','Last Name', 0, NULL, 'string')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('33F30001-8B67-4BD9-917D-A656012392F1', '2F630001-06EF-483B-850B-A65601089B03', 0)
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('87E60001-7423-49BD-AB0A-A65601239766', '2F630001-06EF-483B-850B-A65601089B03', 2)
INSERT INTO Domain (ID, ParentDomainID, Title, IsMultiValue, EnumValue, DataType) VALUES ('32CC0001-A2D3-46F9-BAE6-A6560108AAF6', '1E7A0001-6E2C-4F74-8966-A65601087EBF','Phone', 0, NULL, 'string')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('CAB30001-7FC6-40B7-B508-A65601239BBE', '32CC0001-A2D3-46F9-BAE6-A6560108AAF6', 0)
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('039F0001-CC80-435E-939B-A6560123A074', '32CC0001-A2D3-46F9-BAE6-A6560108AAF6', 2)
INSERT INTO Domain (ID, ParentDomainID, Title, IsMultiValue, EnumValue, DataType) VALUES ('6FD20001-09A9-42A4-AC2B-A6560108B09B', '1E7A0001-6E2C-4F74-8966-A65601087EBF','Email', 0, NULL, 'string')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('06CE0001-376B-4674-B087-A6560123A494', '6FD20001-09A9-42A4-AC2B-A6560108B09B', 0)
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('981D0001-60F6-4557-9D57-A6560123A998', '6FD20001-09A9-42A4-AC2B-A6560108B09B', 2)

INSERT INTO Domain (ID, Title, IsMultiValue, EnumValue, DataType) VALUES ('11580001-B5A1-4815-BC6E-A6560108B6E6','Description', 0, NULL, 'string')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('082C0001-C179-4630-A0C9-A6560123AFC6', '11580001-B5A1-4815-BC6E-A6560108B6E6', 0)
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('86560001-6947-4384-8CB1-A6560123B537', '11580001-B5A1-4815-BC6E-A6560108B6E6', 2)

INSERT INTO Domain (ID, Title, IsMultiValue, EnumValue, DataType) VALUES ('966B0001-2055-4710-88BF-A6560108BF92','Collaboration Requirements', 0, NULL, 'string')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('86010001-1B19-4238-94F7-A6560123BA32', '966B0001-2055-4710-88BF-A6560108BF92', 0)
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('92D50001-F4D8-4712-95E7-A6560123BE90', '966B0001-2055-4710-88BF-A6560108BF92', 2)

INSERT INTO Domain (ID, Title, IsMultiValue, EnumValue, DataType) VALUES ('428D0001-57A8-4A69-B02E-A6560108C757','Research Capabilities', 0, NULL, 'string')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('A0F00001-4282-4165-8839-A6560123C376', '428D0001-57A8-4A69-B02E-A6560108C757', 0)

INSERT INTO Domain (ID, Title, IsMultiValue, EnumValue, DataType) VALUES ('4d5ea63a-6318-45f1-9a89-a62600a6ef00','Willing to Participate In', 1, NULL, 'reference')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('7F970001-CDC6-4D64-8144-A6560124D9C7', '4d5ea63a-6318-45f1-9a89-a62600a6ef00', 0)
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('836c4f41-483d-471d-b7fc-a62600aeb78f', '4d5ea63a-6318-45f1-9a89-a62600a6ef00', 'Observational Research')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('b7236848-ca4e-4f5f-b482-a62600aec6c6', '4d5ea63a-6318-45f1-9a89-a62600a6ef00', 'Clinical Trials')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('bf140bf4-91bf-41f0-ba4a-a62600aed2b9', '4d5ea63a-6318-45f1-9a89-a62600a6ef00', 'Pragmatic Clinical Trials')

INSERT INTO Domain (ID, Title, IsMultiValue, EnumValue, DataType) VALUES ('71f9f9eb-e66d-41f3-87e4-a62600ab03fe','Types of Data Collected', 1, NULL, 'reference')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('B5D00001-6085-44DA-8162-A6560124D48D', '71f9f9eb-e66d-41f3-87e4-a62600ab03fe', 0)
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('0dd059fc-b8ef-4bbd-8a32-a62600b179ee', '71f9f9eb-e66d-41f3-87e4-a62600ab03fe', 'None')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('c7bad56c-99d1-4263-bd04-a62600b18878', '71f9f9eb-e66d-41f3-87e4-a62600ab03fe', 'Outpatient')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('1ff2da55-1c5c-4693-b613-a62600b1ae12', '71f9f9eb-e66d-41f3-87e4-a62600ab03fe', 'Enrollment')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('afea017f-9b90-4d69-8306-a62600b1b688', '71f9f9eb-e66d-41f3-87e4-a62600ab03fe', 'Laboratory Results')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('f3df108b-e3a2-46bf-9e68-a62600b1c14a', '71f9f9eb-e66d-41f3-87e4-a62600ab03fe', 'Biorepositories')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('4618b313-b73c-4518-a426-a62600b1cbe2', '71f9f9eb-e66d-41f3-87e4-a62600ab03fe', 'Patient Reported Behaviors')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('ccfc567d-08e5-42ee-a99e-a62600b1d585', '71f9f9eb-e66d-41f3-87e4-a62600ab03fe', 'Inpatient')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('a16b5588-2768-4122-be3a-a62600b1dfce', '71f9f9eb-e66d-41f3-87e4-a62600ab03fe', 'Pharmacy Dispensings')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('a72e3f30-3fca-49d9-8d3e-a62600b1e91a', '71f9f9eb-e66d-41f3-87e4-a62600ab03fe', 'Demographics')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('2216ecd8-6d98-4726-959b-a62600b1f2d1', '71f9f9eb-e66d-41f3-87e4-a62600ab03fe', 'Vital Signs')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('75e54c21-a27c-4893-8a7c-a62600b1fbf4', '71f9f9eb-e66d-41f3-87e4-a62600ab03fe', 'Patient Reported Outcomes/Health Status')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('95414cd3-b661-4f91-8957-a62600b243d9', '71f9f9eb-e66d-41f3-87e4-a62600ab03fe', 'Prescription Orders')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('f108307b-b8c5-4de4-a6e8-a62600b25065', '71f9f9eb-e66d-41f3-87e4-a62600ab03fe', 'Other')

INSERT INTO Domain (ID, Title, IsMultiValue, EnumValue, DataType) VALUES ('63d0ad61-4910-498c-a48e-a62600acbcb4','Data Models', 1, NULL, 'reference')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('FD760001-8047-4FDB-A347-A65601249C71', '63d0ad61-4910-498c-a48e-a62600acbcb4', 0)
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('8bbeeb58-01df-4fe4-8e76-a62600b43dc9', '63d0ad61-4910-498c-a48e-a62600acbcb4', 'None')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('c2b41962-ff78-493b-af9e-a62600b46986', '63d0ad61-4910-498c-a48e-a62600acbcb4', 'MSCDM')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('860e7db0-0e98-4870-bfb5-a62600b46045', '63d0ad61-4910-498c-a48e-a62600acbcb4', 'HMORN VDW')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('2f01ec11-35c0-401a-81ce-a62600b453e6', '63d0ad61-4910-498c-a48e-a62600acbcb4', 'ESP')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('95cdde93-5cdb-4838-b71c-a62600b4748f', '63d0ad61-4910-498c-a48e-a62600acbcb4', 'I2B2')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('035bffcc-0091-4fd7-9362-a62600b47e58', '63d0ad61-4910-498c-a48e-a62600acbcb4', 'OMOP')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('bd017965-00ec-4239-8559-a62600b496ef', '63d0ad61-4910-498c-a48e-a62600acbcb4', 'PCORnet CDM')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('16c392e9-ff26-47c6-ae6f-a62600b48c85', '63d0ad61-4910-498c-a48e-a62600acbcb4', 'Other')

INSERT INTO Domain (ID, Title, IsMultiValue, EnumValue, DataType) VALUES ('93100001-F3A9-4F26-A08A-A656010CBAD6','Data Period Range', 0, NULL, 'group')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('7B5C0001-B6B8-4252-B4E4-A6560124A237', '93100001-F3A9-4F26-A08A-A656010CBAD6', 2)
INSERT INTO Domain (ID, ParentDomainID, Title, IsMultiValue, EnumValue, DataType) VALUES ('067A0001-389A-4D1C-8C3B-A6560108F7EE','93100001-F3A9-4F26-A08A-A656010CBAD6', 'Data Period Start Year', 0, NULL, 'int')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('7BF20001-B5BB-44C3-9EC8-A6560124A804', '067A0001-389A-4D1C-8C3B-A6560108F7EE', 2)
INSERT INTO Domain (ID, ParentDomainID, Title, IsMultiValue, EnumValue, DataType) VALUES ('A1690001-61CC-4612-AAAB-A6560108FD14','93100001-F3A9-4F26-A08A-A656010CBAD6', 'Data Period End Year', 0, NULL, 'int')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('6ED40001-D97A-46C3-9FCF-A6560124AD5F', 'A1690001-61CC-4612-AAAB-A6560108FD14', 2)
INSERT INTO Domain (ID, ParentDomainID, Title, IsMultiValue, EnumValue, DataType) VALUES ('0960ee16-a76b-415d-b6df-a62600b969db','93100001-F3A9-4F26-A08A-A656010CBAD6', 'Data Update Frequency', 0, NULL, 'reference')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('420C0001-5D5A-4CFF-A8C6-A6560124B28D', '0960ee16-a76b-415d-b6df-a62600b969db', 2)
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('318e72a4-863c-4115-b4e6-a62600ba1bd9', '0960ee16-a76b-415d-b6df-a62600b969db', 'None', '1')
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('142bafef-8050-4a2d-9e25-a62600ba261c', '0960ee16-a76b-415d-b6df-a62600b969db', 'Daily', '2')
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('4de3c196-15d4-409e-8bcc-a62600ba3118', '0960ee16-a76b-415d-b6df-a62600b969db', 'Weekly', '3')
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('491f5ea2-d892-425b-ad5d-a62600ba3e0a', '0960ee16-a76b-415d-b6df-a62600b969db', 'Monthly', '4')
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('b59299cb-263f-493a-a9cc-a62600ba4746', '0960ee16-a76b-415d-b6df-a62600b969db', 'Quarterly', '5')
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('aed999bb-97e4-4920-acbc-a62600ba510e', '0960ee16-a76b-415d-b6df-a62600b969db', 'Semi-Annually', '6')
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('f72d2835-9011-4e16-af1e-a62600ba5c03', '0960ee16-a76b-415d-b6df-a62600b969db', 'Annually', '7')
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('5ea4e0ed-09e5-4a43-922e-a62600ba6596', '0960ee16-a76b-415d-b6df-a62600b969db', 'Other', '8')

INSERT INTO Domain (ID, Title, IsMultiValue, EnumValue, DataType) VALUES ('CA4C0001-A49A-49A8-90ED-A656010908FA','Data Model Supported', 0, NULL, 'reference')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('5A140001-1E80-46F9-B868-A65601246870', 'CA4C0001-A49A-49A8-90ED-A656010908FA', 2)
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('7F4E0001-2FE7-4CCD-AED1-A656010911B1', 'CA4C0001-A49A-49A8-90ED-A656010908FA', 'None', '1')
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('F2330001-5DC3-4F7D-AD73-A65601091886', 'CA4C0001-A49A-49A8-90ED-A656010908FA', 'MSCDM', '2')
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('45AE0001-A022-48FD-A8AF-A65601091D85', 'CA4C0001-A49A-49A8-90ED-A656010908FA', 'HMORN VDW', '3')
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('86910001-7965-45C7-AAAE-A65601092368', 'CA4C0001-A49A-49A8-90ED-A656010908FA', 'ESP', '4')
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('8F6A0001-945C-4A34-AFC6-A656010929ED', 'CA4C0001-A49A-49A8-90ED-A656010908FA', 'I2B2', '5')
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('7B290001-0BD2-48C3-8268-A65601093005', 'CA4C0001-A49A-49A8-90ED-A656010908FA', 'OMOP', '6')
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('696F0001-A010-49FA-8FED-A65601093649', 'CA4C0001-A49A-49A8-90ED-A656010908FA', 'PCORnet CDM', '8')
INSERT INTO DomainReference (ID, DomainID, Title, [Value]) VALUES ('5B300001-E456-4B3B-A347-A65601093CA0', 'CA4C0001-A49A-49A8-90ED-A656010908FA', 'Other', '7')

INSERT INTO Domain (ID, Title, IsMultiValue, EnumValue, DataType) VALUES ('ae41b949-92c2-4ef7-876e-a62600bbeb57','Inpatient Encounters', 1, NULL, 'reference')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('34650001-74EF-492D-84B9-A65601246E5F', 'ae41b949-92c2-4ef7-876e-a62600bbeb57', 2)
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('b1f19d53-06ab-419a-a523-a62600c4d3ef', 'ae41b949-92c2-4ef7-876e-a62600bbeb57', 'Encounter ID')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('14b4756b-3c11-4612-84fb-a62600c4dfe5', 'ae41b949-92c2-4ef7-876e-a62600bbeb57', 'Dates of Service')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('5fbb5511-475c-4fb7-9578-a62600c51b3a', 'ae41b949-92c2-4ef7-876e-a62600bbeb57', 'Provider/Facility Identifier')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('0f7a9156-f9a6-460b-a7e7-a62600c525c2', 'ae41b949-92c2-4ef7-876e-a62600bbeb57', 'ICD-9 Procedures')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('145cadc4-be69-4123-a75f-a62600c533dc', 'ae41b949-92c2-4ef7-876e-a62600bbeb57', 'ICD-10 Procedures')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('056018ac-f164-49ba-88b1-a62600c53cff', 'ae41b949-92c2-4ef7-876e-a62600bbeb57', 'ICD-9 Diagnosis')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('12157696-e9e3-4f90-8ee5-a62600c549e0', 'ae41b949-92c2-4ef7-876e-a62600bbeb57', 'ICD-10 Diagnosis')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('1b4b6393-2399-4cfd-8318-a62600c5523f', 'ae41b949-92c2-4ef7-876e-a62600bbeb57', 'SNOMED')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('e05d9033-73f9-4dc9-8614-a62600c55afb', 'ae41b949-92c2-4ef7-876e-a62600bbeb57', 'HCPCS (including CPT)')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('d1a4aee3-413a-4b8a-b849-a62600c5652a', 'ae41b949-92c2-4ef7-876e-a62600bbeb57', 'Disposition')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('7685b801-7974-4574-8136-a62600c56ecd', 'ae41b949-92c2-4ef7-876e-a62600bbeb57', 'Discharge Status')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('28d4092c-a14a-4c4d-b089-a62600c57733', 'ae41b949-92c2-4ef7-876e-a62600bbeb57', 'Other')

INSERT INTO Domain (ID, Title, IsMultiValue, EnumValue, DataType) VALUES ('1d7a0dd2-a1a3-4cc5-b3f9-a62600c46431','Demographics', 1, NULL, 'reference')
INSERT INTO DomainUse (ID, DomainID, EntityType) VALUES ('6C9E0001-D50F-406D-A099-A6560124734C', '1d7a0dd2-a1a3-4cc5-b3f9-a62600c46431', 2)
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('bb90ed02-2df6-4219-a495-a62600c583ad', '1d7a0dd2-a1a3-4cc5-b3f9-a62600c46431', 'Sex')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('32a60fce-f703-46e1-be88-a62600c58dbe', '1d7a0dd2-a1a3-4cc5-b3f9-a62600c46431', 'Date of Birth')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('a4a26325-3921-4819-a8c6-a62600c59625', '1d7a0dd2-a1a3-4cc5-b3f9-a62600c46431', 'Date of Death')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('556a46ad-bebf-468d-b834-a62600c59e4c', '1d7a0dd2-a1a3-4cc5-b3f9-a62600c46431', 'Zip Code')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('62b1f51b-ec64-45ca-b183-a62600c5a7cf', '1d7a0dd2-a1a3-4cc5-b3f9-a62600c46431', 'Race')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('68b94ec3-88b4-4e6f-ba48-a62600c5b137', '1d7a0dd2-a1a3-4cc5-b3f9-a62600c46431', 'Ethnicity')
INSERT INTO DomainReference (ID, DomainID, Title) VALUES ('71e44f23-1dcb-4e6b-83c7-a62600c5b923', '1d7a0dd2-a1a3-4cc5-b3f9-a62600c46431', 'Other')
