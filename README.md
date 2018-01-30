# Cross Network Directory Service (CNDS)

This Repository contains the source code for the Cross Network Directory Service project. As CNDS is built on top of PopMedNet (PMN) source code, you will need to have an instance of PopMedNet v.6 and above.
PMN currently enables creation, operation, and governance of distributed health data networks. It supports distributed within-network querying for several large-scale health data networks. The Cross Network Directory Service (CNDS) extends PMN’s existing functionality to enable cross-network discovery of potential collaborators and data sources and querying of those sources while enforcing governance rules. A flexible data model to capture the metadata collected was developed and integrates CNDS with PopMedNet. As such, a PopMedNet instance needs to be deployed to use CNDS. CNDS is a set of services that can be invoked by PMN instances, rather than by wholesale modification of PMN. CNDS provides a standard set of functions that PMN can call upon through APIs.
Once you clone the code and have the files locally, you will need to unzip the following files before starting the set up process. 
Lpp.Dns.Model/SQLScripts/Archive/DNS2_c_optional_MedicalCodes.sql
DataMartClientDBSetup/Demonstration Query Tool.mdb

After unzipping the files open the word document PopMedNet CNDS Build v3.docx to follow instructions on setting up an instance of CNDS.


Please reach out to us at https://popmednet.atlassian.net/servicedesk/customer/portal/1/group/10 with questions or to report any problems.

