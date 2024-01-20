#!/bin/bash

BAHMNI_DOCKER_ENV_FILE=.env

source ./backup_restore/backup_utils.sh
source ${BAHMNI_DOCKER_ENV_FILE}

# Set the backup folder path
BACKUP_ROOT_FOLDER="./backup-artifacts"

# Get the current datetime
datetime=$(date +'%Y-%m-%d_%H-%M-%S')

# Create the backup folder with the current datetime
backup_subfolder_path="$BACKUP_ROOT_FOLDER/$datetime"
mkdir -p "$backup_subfolder_path"

log_info "Saving backup to $backup_subfolder_path..."


openmrs_db_backup_file_path=$backup_subfolder_path/openmrsdb_backup.sql
reports_db_backup_file_path=$backup_subfolder_path/reportsdb_backup.sql
openelis_db_backup_file_path=$backup_subfolder_path/openelisdb_backup.sql
odoo_db_backup_file_path=$backup_subfolder_path/odoodb_backup.sql
dcm4chee_db_backup_file_path=$backup_subfolder_path/dcm4cheedb_backup.sql
pacs_integration_db_backup_file_path=$backup_subfolder_path/pacs_integrationdb_backup.sql

hipservice_db_backup_file_path="$backup_subfolder_path/hipservicedb_backup.sql"
hip_atomfeed_db_backup_file_path="$backup_subfolder_path/hip_atomfeeddb_backup.sql"
hiu_db_backup_file_path="$backup_subfolder_path/hiudb_backup.sql"
otpservice_db_backup_file_path="$backup_subfolder_path/otpservicedb_backup.sql"


openmrs_service_name="openmrs"
reports_service_name="reports"
dcm4chee_service_name="dcm4chee"
openmrs_db_service_name="openmrsdb"
reports_db_service_name="reportsdb"
openelis_db_service_name="openelisdb"
odoo_db_service_name="odoodb"
dcm4chee_db_service_name="pacsdb"
pacs_integration_db_service_name="pacsdb"
abdm_db_service_name="db"

log_info "Taking backup for OpenMRS Database"
backup_db "mysql" $OPENMRS_DB_NAME $OPENMRS_DB_USERNAME $OPENMRS_DB_PASSWORD $openmrs_db_service_name $openmrs_db_backup_file_path

log_info "Taking backup for Reports Database"
backup_db "mysql" $REPORTS_DB_NAME $REPORTS_DB_USERNAME $REPORTS_DB_PASSWORD $reports_db_service_name $reports_db_backup_file_path

log_info "Taking backup for OpenELIS Database"
backup_db "postgres" "clinlims" $OPENELIS_DB_USER $OPENELIS_DB_PASSWORD $openelis_db_service_name $openelis_db_backup_file_path

# log_info "Taking backup for Odoo Database"
# backup_db "postgres" $ODOO_DB_NAME $ODOO_DB_USER $ODOO_DB_PASSWORD $odoo_db_service_name $odoo_db_backup_file_path

log_info "Taking backup for DCM4CHEE Database"
backup_db "postgres" $DCM4CHEE_DB_NAME $DCM4CHEE_DB_USERNAME $DCM4CHEE_DB_PASSWORD $dcm4chee_db_service_name $dcm4chee_db_backup_file_path

log_info "Taking backup for PACS Integration Database"
backup_db "postgres" $PACS_INTEGRATION_DB_NAME $PACS_INTEGRATION_DB_USERNAME $PACS_INTEGRATION_DB_PASSWORD $pacs_integration_db_service_name $pacs_integration_db_backup_file_path

log_info "Taking backup for HIP Database"
backup_db "postgres" $HIP_DB_NAME $HIP_DB_USER $HIP_DB_PASSWORD $abdm_db_service_name $hipservice_db_backup_file_path

log_info "Taking backup for HIP Atomfeed Database"
backup_db "postgres" $HIP_ATOMFEED_DB_NAME $HIP_DB_USER $HIP_DB_PASSWORD $abdm_db_service_name $hip_atomfeed_db_backup_file_path

log_info "Taking backup for HIU Database"
backup_db "postgres" $HIU_DB_NAME $HIU_DB_USER $HIU_DB_PASSWORD $abdm_db_service_name $hiu_db_backup_file_path

log_info "Taking backup for OTP Database"
backup_db "postgres" $OTP_DB_NAME $OTP_DB_USER $OTP_DB_PASSWORD $abdm_db_service_name $otpservice_db_backup_file_path

log_info "Taking backup for Patient-Documents"
backup_container_file_system $openmrs_service_name "/home/bahmni/document_images" "$BACKUP_ROOT_FOLDER"

log_info "Taking backup for Uploaded-Results"
backup_container_file_system $openmrs_service_name "/home/bahmni/uploaded_results" "$BACKUP_ROOT_FOLDER"

log_info "Taking backup for Uploaded-Files"
backup_container_file_system $openmrs_service_name "/home/bahmni/uploaded-files" "$BACKUP_ROOT_FOLDER"

log_info "Taking backup for Patient-Images"
backup_container_file_system $openmrs_service_name "/home/bahmni/patient_images" "$BACKUP_ROOT_FOLDER"

log_info "Taking backup for Clinical-Forms"
backup_container_file_system $openmrs_service_name "/home/bahmni/clinical_forms" "$BACKUP_ROOT_FOLDER"

log_info "Taking backup for Configuration Checksums"
backup_container_file_system $openmrs_service_name "/openmrs/data/configuration_checksums" "$BACKUP_ROOT_FOLDER"

log_info "Taking backup for Queued Reports results"
backup_container_file_system $reports_service_name "/home/bahmni/reports" "$BACKUP_ROOT_FOLDER"

# log_info "Taking backup for DCM4CHEE Archive"
# backup_container_file_system $dcm4chee_service_name "/var/lib/bahmni/dcm4chee/server/default/archive/." "$BACKUP_ROOT_FOLDER/dcm4chee_archive"

echo "Backup completed at $(date)"