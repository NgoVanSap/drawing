<template>
<div v-if="isActiveComponent" class="main-ui">
    <div class="main-content">
        <div class="top-ui">
            <div class="top-title">{{$t('ColumnConfiguration')}}</div>
            <div class="top-icon"><i class="fas fa-times close-icon" @click="handleClose"></i></div>
        </div>
        <div class="center-ui">
            <table class="table-content">
                <thead>
                    <th class="fix-header th-no">{{ $t('No') }}</th>
                    <th class="fix-header th-name">{{$t('ColumnName')}}</th>
                    <th class="fix-header th-status">{{$t('Status')}}</th>
                </thead>
                <tbody>
                    <tr v-for="(column, index) in columns" :key="index">
                        <td class="td-no">{{ index + 1 }}</td>
                        <td class="td-name">{{ column.name }}</td>
                        <td class="td-status"><input type="checkbox" class="form-check-input" id="flexSwitchCheckDefault" v-model="isCheckColumn[index]"></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="bottom-ui">
            <v-btn class="button_save" @click="handleSave" style="font-family: 'Poppins', sans-serif">{{ $t('Save') }}</v-btn>
            <v-btn class="button_cancel" @click="HandleCancel" style="font-family: 'Poppins', sans-serif">{{ $t('Cancel') }}</v-btn>
        </div>
    </div>
</div>
</template>

<script>
import axios from 'axios';
export default {
    name: 'component-column-configuration',
    components: {

    },
    props: {
        isActiveComponent: {
            type: Boolean,
            request: true,
            default: false
        }
    },

    data() {
        return {
            columns: [{
                    name: this.$t('Author'),
                },
                {
                    name: this.$t('DateAccessed'),
                },
                {
                    name: this.$t('Status'),
                },
                {
                    name: this.$t('Revision'),
                },
                {
                    name: this.$t('Size'),
                },
                {
                    name: this.$t('AutomRev'),
                },
                {
                    name: this.$t('Description'),
                },
                {
                    name: this.$t('Language'),
                },
                {
                    name: this.$t('Sheet'),
                },
                {
                    name: this.$t('DocumentNumber'),
                }
            ],
            isCheckColumn: [true, true, true, true, true, true, true, true, true, true],
        }
    },

    watch: {
        '$i18n.locale': 'updateColumns',
        isActiveComponent(newValue, oldValue) {
            console.log('[column_configuration] change from [', oldValue, '] to [', newValue, ']');
            if (oldValue == false && newValue == true) {
                this.loadData();
            }
        },
    },
    methods: {
        updateColumns() {
            this.columns = [{
                    name: this.$t('Author'),
                },
                {
                    name: this.$t('DateAccessed'),
                },
                {
                    name: this.$t('Status'),
                },
                {
                    name: this.$t('Revision'),
                },
                {
                    name: this.$t('Size'),
                },
                {
                    name: this.$t('AutomRev'),
                },
                {
                    name: this.$t('Description'),
                },
                {
                    name: this.$t('Language'),
                },
                {
                    name: this.$t('Sheet'),
                },
                {
                    name: this.$t('DocumentNumber'),
                }
            ];

            console.log("(updateColumns) Columns Update: ", this.columns);
        },
        handleClose() {
            this.$emit("signalClose");
        },
        async handleSave() {
            const jsonData = {
                user_id: this.$globalVariable.USER_INFO.userID,
                author: this.isCheckColumn[0] ? 1 : 0,
                last_check_in: this.isCheckColumn[1] ? 1 : 0,
                status: this.isCheckColumn[2] ? 1 : 0,
                revision: this.isCheckColumn[3] ? 1 : 0,
                size: this.isCheckColumn[4] ? 1 : 0,
                autom_rev: this.isCheckColumn[5] ? 1 : 0,
                description: this.isCheckColumn[6] ? 1 : 0,
                language: this.isCheckColumn[7] ? 1 : 0,
                sheet: this.isCheckColumn[8] ? 1 : 0,
                document_number: this.isCheckColumn[9] ? 1 : 0,
            };
            // console.log('columns NAME: ', this.columns.name[1]);

            const jsonString = JSON.stringify(jsonData);
            console.log("[column_configuration] (handleSave) jsonString: ", jsonString);
            await axios.post(this.$globalVariable.URL_API + '/Option/save_column_configuration/', jsonString, {
                headers: {
                    'Content-Type': 'application/json'  
                }
            }).then(response => {
                console.log("[column_configuration] (handleSave) response: ", response.data);
                this.$globalVariable.COLUMN_CONFIGURATION.author = this.isCheckColumn[0];
                this.$globalVariable.COLUMN_CONFIGURATION.last_check_in = this.isCheckColumn[1];
                this.$globalVariable.COLUMN_CONFIGURATION.status = this.isCheckColumn[2];
                this.$globalVariable.COLUMN_CONFIGURATION.revision = this.isCheckColumn[3];
                this.$globalVariable.COLUMN_CONFIGURATION.size = this.isCheckColumn[4];
                this.$globalVariable.COLUMN_CONFIGURATION.autom_rev = this.isCheckColumn[5];
                this.$globalVariable.COLUMN_CONFIGURATION.description = this.isCheckColumn[6];
                this.$globalVariable.COLUMN_CONFIGURATION.language = this.isCheckColumn[7];
                this.$globalVariable.COLUMN_CONFIGURATION.sheet = this.isCheckColumn[8];
                this.$globalVariable.COLUMN_CONFIGURATION.document_number = this.isCheckColumn[9];
                console.log("(handleSave) document_number: ", this.$globalVariable.COLUMN_CONFIGURATION.document_number);
                this.$emit("signalClose");
            }).catch(error => {
                console.error("[column_configuration] (handleSave) error: ", error);
            })
        },
        HandleCancel() {
            this.$emit("signalClose");
        },
        loadData() {
            this.isCheckColumn[0] = this.$globalVariable.COLUMN_CONFIGURATION.author;
            this.isCheckColumn[1] = this.$globalVariable.COLUMN_CONFIGURATION.last_check_in;
            this.isCheckColumn[2] = this.$globalVariable.COLUMN_CONFIGURATION.status;
            this.isCheckColumn[3] = this.$globalVariable.COLUMN_CONFIGURATION.revision;
            this.isCheckColumn[4] = this.$globalVariable.COLUMN_CONFIGURATION.size;
            this.isCheckColumn[5] = this.$globalVariable.COLUMN_CONFIGURATION.autom_rev;
            this.isCheckColumn[6] = this.$globalVariable.COLUMN_CONFIGURATION.description;
            this.isCheckColumn[7] = this.$globalVariable.COLUMN_CONFIGURATION.language;
            this.isCheckColumn[8] = this.$globalVariable.COLUMN_CONFIGURATION.sheet;
            this.isCheckColumn[9] = this.$globalVariable.COLUMN_CONFIGURATION.document_number;
        }
    },
    computed: {

    },

}
</script>

<style scoped>
@import '@mdi/font/css/materialdesignicons.min.css';

/* CSS to MAIN */
.main-ui {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
}

.main-content {
    font-family: Arial, Helvetica, sans-serif;
    background-color: #fff;
    padding: 0px;
    border-radius: 6px;
    width: 470px;
}

/* CSS to TOP */
.top-ui {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: #000;
    border: none;
    border-top-left-radius: 6px;
    border-top-right-radius: 6px;
    padding-right: 5px;
    color: #fff;
}

.top-title {
    flex: 1;
    height: 40px;
    padding-top: 10px;
    border-radius: 5px;
    font-weight: bold;
    text-align: left;
    padding-left: 10px;
}

.top-icon {
    cursor: pointer;
    margin-right: 10px;
    color: #fff;
}

.top-icon i {
    font-size: 20px;
    color: #fff;
}

.top-icon i:hover {
    font-size: 20px;
    color: #757575;
}

/* CSS to CENTER */
.center-ui {
    padding: 10px;
    border: none;
    min-height: 35px;
    max-height: 435px;
    background-color: #fff;
    width: 100%;
    overflow-y: auto;
    /* background: linear-gradient(to bottom, #B3E5FC, #fff); */
}

.table-content {
    width: 100%;
    border-collapse: collapse;
    height: 35px;
    table-layout: fixed;
}

.fix-header {
    position: sticky;
    top: 0;
    background-color: #fff;
    /* background: linear-gradient(to bottom, #B3E5FC, #fff); */
}

.table-content th {
    padding: 8px;
    border: 1px solid #B5B5B5;
    height: 30px;
    text-align: center;
}

.table-content tr,
.table-content td {
    border: 1px solid #B5B5B5;
    height: 40px;
}

.th-no {
    width: 50px;
}

.th-name {
    width: 180px;
}

.th-status {
    width: 70px;
}

.td-no {
    text-align: center;
}

.td-name {
    text-align: left;
    padding-left: 20px;
}

.td-status {
    text-align: center;
}

/* CSS to BOTTOM */
.bottom-ui {
    display: flex;
    height: 60px;
    width: 100%;
    justify-content: center;
    color: #fff;
    padding-top: 10px;
    padding-bottom: 10px;
    border: none;
}

.button_save {
    margin-right: 15px;
    min-width: 110px;
}

.button_cancel {
    margin-left: 15px;
    min-width: 110px;
}
</style>
