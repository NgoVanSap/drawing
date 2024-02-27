<template>
<div v-if="isActiveFormSetting" class="main-privilege">
    <div class="content">
        <header>
            <div class="header">
                <div class="title">{{ userid }}</div>
                <div class="icon"><i class="fas fa-times close-icon" @click="HandleCancel"></i></div>
            </div>
        </header>
        <div class="settings">
            <div class="tab-table">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th class="fix-header th-no">{{$t('No')}}</th>
                            <th class="fix-header th-status">{{$t('Status')}}</th>
                            <th class="fix-header th-name">{{$t('DirectoryName')}}</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(privilegeItem, index) in privilegeList" :key="privilegeItem.id">
                            <td class="td-no">{{ privilegeItem.id }}</td>
                            <td class="td-status"><input type="checkbox" class="form-check-input" id="flexSwitchCheckDefault" v-model="isCheckPrivilege[index]"></td>
                            <td class="td-name">{{ privilegeItem.name }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div class="option">
            <v-btn class="button" @click="handleSave" style="font-family: 'Poppins', sans-serif">{{$t('Save')}}</v-btn>
            <v-btn class="button" @click="HandleCancel" style="font-family: 'Poppins', sans-serif">{{$t('Cancel')}}</v-btn>
        </div>
    </div>
</div>
</template>

<script>
import axios from 'axios';
export default {
    components: {

    },
    props: {
        isActiveFormSetting: {
            type: Boolean,
            required: true,
            default: false
        },
        userid: {
            type: String,
            required: true,
            default: ""
        },
        indexID: {
            type: Number,
            required: true,
            default: 0
        }
    },
    data() {
        return {
            privilegeList: [],
            chao_thau: false,
            hop_dong: false,
            xay_dung: false,
            dien: false,
            co_khi: false,
            layout_dq2: false,
            quy_dinh_thiet_bi: false,
            hdsd_e_office: false,
            van_ban: false,
            data_dung_chung: false,
            pccc: false,
            isCheckPrivilege: [],
        }
    },
    methods: {
        async handleSave() {
            this.chao_thau = this.isCheckPrivilege[0];
            this.hop_dong = this.isCheckPrivilege[1];
            this.xay_dung = this.isCheckPrivilege[2];
            this.dien = this.isCheckPrivilege[3];
            this.co_khi = this.isCheckPrivilege[4];
            this.layout_dq2 = this.isCheckPrivilege[5];
            this.quy_dinh_thiet_bi = this.isCheckPrivilege[6];
            this.hdsd_e_office = this.isCheckPrivilege[7];
            this.van_ban = this.isCheckPrivilege[8];
            this.data_dung_chung = this.isCheckPrivilege[9];
            this.pccc = this.isCheckPrivilege[10];

            console.log("(PopupSettingUser) [save] chao_thau: ", this.chao_thau);
            console.log("(PopupSettingUser) [save] hop_dong: ", this.hop_dong);
            console.log("(PopupSettingUser) [save] xay_dung: ", this.xay_dung);
            console.log("(PopupSettingUser) [save] dien: ", this.dien);
            console.log("(PopupSettingUser) [save] co_khi: ", this.co_khi);
            console.log("(PopupSettingUser) [save] layout_dq2: ", this.layout_dq2);
            console.log("(PopupSettingUser) [save] quy_dinh_thiet_bi: ", this.quy_dinh_thiet_bi);
            console.log("(PopupSettingUser) [save] hdsd_e_office: ", this.hdsd_e_office);
            console.log("(PopupSettingUser) [save] van_ban: ", this.van_ban);
            console.log("(PopupSettingUser) [save] data_dung_chung: ", this.data_dung_chung);
            console.log("(PopupSettingUser) [save] pccc: ", this.pccc);

            const jsonData = {
                userid: this.userid,
                chao_thau: this.chao_thau,
                hop_dong: this.hop_dong,
                xay_dung: this.xay_dung,
                dien: this.dien,
                co_khi: this.co_khi,
                layout_dq2: this.layout_dq2,
                quy_dinh_thiet_bi: this.quy_dinh_thiet_bi,
                hdsd_e_office: this.hdsd_e_office,
                van_ban: this.van_ban,
                data_dung_chung: this.data_dung_chung,
                pccc: this.pccc
            };
            const jsonString = JSON.stringify(jsonData);
            console.log("(PopupSettingUser) [save] jsonString: ", jsonString);
            await axios.post(this.$globalVariable.URL_API + '/ManageAccess/save_privilege_account/', jsonString, {
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then(response => {
                console.log("(PopupSettingUser) [save] response: ", response.data);
                const jsonString = response.data;
                if (jsonString == "Error") {
                    console.error("(PopupSettingUser) [save] Cannot get privilege for user");
                } else {
                    console.log("(PopupSettingUser) [save] success");
                    this.$emit("signalHandleCancel", this.indexID);
                }
            }).catch(error => {
                console.error("(PopupSettingUser) [save] error: ", error);
            })
        },
        HandleCancel() {
            this.$emit("signalHandleCancel", this.indexID);
        },
        getNameFolder(id) {
            let result = "";
            switch (id) {
                case 0:
                    result = "1. Chao thau";
                    break;
                case 1:
                    result = "2. Hop dong";
                    break;
                case 2:
                    result = "3. Xay dung";
                    break;
                case 3:
                    result = "4. Dien";
                    break;
                case 4:
                    result = "5. Co khi";
                    break;
                case 5:
                    result = "6. Layout DQ2";
                    break;
                case 6:
                    result = "7. Quy dinh thiet bi";
                    break;
                case 7:
                    result = "8. HDSD E-Office";
                    break;
                case 8:
                    result = "9. Van ban";
                    break;
                case 9:
                    result = "10. DATA dung chung";
                    break;
                case 10:
                    result = "10. PCCC";
                    break;
                default:
                    result = "";
                    break;
            }
            return result;
        },
        getStatusFolder(id) {
            let result = false;
            switch (id) {
                case 0:
                    result = this.chao_thau;
                    break;
                case 1:
                    result = this.hop_dong;
                    break;
                case 2:
                    result = this.xay_dung;
                    break;
                case 3:
                    result = this.dien;
                    break;
                case 4:
                    result = this.co_khi;
                    break;
                case 5:
                    result = this.layout_dq2;
                    break;
                case 6:
                    result = this.quy_dinh_thiet_bi;
                    break;
                case 7:
                    result = this.hdsd_e_office;
                    break;
                case 8:
                    result = this.van_ban;
                    break;
                case 9:
                    result = this.data_dung_chung;
                    break;
                case 10:
                    result = this.pccc;
                    break;
                default:
                    result = false;
                    break;
            }
            return result;
        },
        async getPrivilege() {
            console.log("(PopupSettingUser) userID: ", this.userid);
            this.privilegeList = [];
            this.isCheckPrivilege = [];
            const jsonData = {
                userID: this.userid
            };
            const jsonString = JSON.stringify(jsonData);
            console.log("(PopupSettingUser) jsonString: ", jsonString);
            await axios.post(this.$globalVariable.URL_API + '/ManageAccess/get_privilege_account/', jsonString, {
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then(response => {
                console.log("(PopupSettingUser) response: ", response.data);
                const jsonString = response.data;
                if (jsonString == "Error") {
                    console.error("(PopupSettingUser) Cannot get privilege for user");
                } else {
                    this.chao_thau = jsonString["chao_thau"];
                    this.hop_dong = jsonString["hop_dong"];
                    this.xay_dung = jsonString["xay_dung"];
                    this.dien = jsonString["dien"];
                    this.co_khi = jsonString["co_khi"];
                    this.layout_dq2 = jsonString["layout_dq2"];
                    this.quy_dinh_thiet_bi = jsonString["quy_dinh_thiet_bi"];
                    this.hdsd_e_office = jsonString["hdsd_e_office"];
                    this.van_ban = jsonString["van_ban"];
                    this.data_dung_chung = jsonString["data_dung_chung"];
                    this.pccc = jsonString["pccc"];
                    console.log("(PopupSettingUser) chao_thau: ", this.chao_thau);
                    console.log("(PopupSettingUser) hop_dong: ", this.hop_dong);
                    console.log("(PopupSettingUser) xay_dung: ", this.xay_dung);
                    console.log("(PopupSettingUser) dien: ", this.dien);
                    console.log("(PopupSettingUser) co_khi: ", this.co_khi);
                    console.log("(PopupSettingUser) layout_dq2: ", this.layout_dq2);
                    console.log("(PopupSettingUser) quy_dinh_thiet_bi: ", this.quy_dinh_thiet_bi);
                    console.log("(PopupSettingUser) hdsd_e_office: ", this.hdsd_e_office);
                    console.log("(PopupSettingUser) van_ban: ", this.van_ban);
                    console.log("(PopupSettingUser) data_dung_chung: ", this.data_dung_chung);
                    console.log("(PopupSettingUser) pccc: ", this.pccc);

                    for (let i = 0; i < 11; i++) {
                        let item = {
                            id: i + 1,
                            status: this.getStatusFolder(i),
                            name: this.getNameFolder(i)
                        }
                        this.isCheckPrivilege[i] = this.getStatusFolder(i);
                        console.log("(PopupSettingUser) statis at ", i, " = ", this.isCheckPrivilege[i]);
                        this.privilegeList.push(item);
                    }
                }
            }).catch(error => {
                console.error("(PopupSettingUser) error: ", error);
            })
        }
    },
    computed: {

    },
    watch: {
        isActiveFormSetting(newValue, oldValue) {
            console.log('(handlePrivilegeDetail) (isActiveFormSetting) change from [', oldValue, '] to [', newValue, '] for userID: ', this.userid);
            if (oldValue == false && newValue == true) {
                this.getPrivilege();
            }
        }
    },
    mounted() {

    }
}
</script>

<style scoped>
@import '@mdi/font/css/materialdesignicons.min.css';

.main-privilege {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.3);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
}

.content {
    position: relative;
    font-family: Arial, Helvetica, sans-serif;
    background-color: #fff;
    padding: 0px;
    border: 4px;
    width: 500px;
    height: 45%;
    min-height: 690px;

    outline: none;
    border-color: #fff;
    box-shadow: 0 0 4px #fff;
}

.header {
    display: flex;
    height: 50px;
    width: 100%;
    justify-content: space-between;
    align-items: center;
    vertical-align: middle;
    background-color: #000;
    padding-right: 5px;
    color: #fff;
}

.title {
    border-radius: 5px;
    font-weight: bold;
    padding-left: 10px;
    border: none;
    text-align: left;
    width: 78%;
}

.icon {
    text-align: right;
    cursor: pointer;
    margin-right: 10px;
    color: #fff;
    width: 18%;
}

.icon i {
    font-size: 20px;
    color: #fff;
}

.icon i:hover {
    font-size: 20px;
    color: #757575;
}

.settings {
    position: relative;
    align-items: center;
    border: none;
    width: 100%;
    height: calc(100% - 120px);
    justify-content: center;
}

.tab-table {
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    position: absolute;
    display: flex;
    align-items: center;
    border: none;
    background-color: #fff;
    width: 95%;
    height: 95%;
    overflow-y: auto;
    justify-content: center;
}

.custom-table {
    position: absolute;
    top: 0;
    width: 99%;
    border-collapse: collapse;
    table-layout: fixed;
    padding: 10px;
    border: none;
    float: inline-start;
}

.fix-header {
    position: sticky;
    top: 0;
    background-color: #fff;
    /* background: linear-gradient(to bottom, #B3E5FC, #fff); */
}

.custom-table th {
    padding: 8px;
    border: 1px solid #B5B5B5;
    height: 30px;
    text-align: center;
}

.custom-table tr,
.custom-table td {
    padding: 10px;
    border: 1px solid #B5B5B5;
}

.th-id {
    width: 15%;
}

.th-status {
    width: 25%;
}

.th-name {
    width: 60%;
}

.td-id {
    text-align: center;
}

.td-status {
    text-align: center;
}

.td-name {
    text-align: left;
}

.option {
    display: flex;
    height: 70px;
    width: 100%;
    justify-content: flex-end;
    padding-right: 5px;
    color: #fff;
    padding-top: 10px;
    padding-bottom: 20px;
    border: none;
}

.button {
    margin-right: 20px;
}
</style>
