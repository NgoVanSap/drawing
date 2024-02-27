<template>
<div v-if="isActiveFormPrivilege" class="main">
    <div class="content">
        <header>
            <div class="header">
                <div class="title">{{ $t('AccountManagement') }}</div>
                <div class="icon"><i class="fas fa-times close-icon" @click="HandleCancel"></i></div>
            </div>
            <div class="menu-search">
                <div class="content-search">
                    <input type="text" class="input" v-bind:class="{'disabled' : active_icon_loading}" ref="inputValue" />
                    <button @click="HandleSearch" class="open-popup"><i v-if="!active_icon_loading" class="icon-open-popup"></i><i v-if="active_icon_loading" class="icon_loading"></i>{{$t('Search')}}</button>
                </div>
            </div>

            <div class="tab-table">
                <table class="custom-table">
                    <thead>
                        <tr>
                            <th class="fix-header th-id">{{$t('No')}}</th>
                            <th class="fix-header th-fullname">{{ $t('FullName') }}</th>
                            <th class="fix-header th-userid">{{ $t('EmployeeNumber') }}</th>
                            <th class="fix-header th-position">{{ $t('JobPosition') }}</th>
                            <th class="fix-header th-area">{{ $t('WorkPlace') }}</th>
                            <th class="fix-header th-hour">{{ $t('WorkingHours') }}</th>
                            <th class="fix-header th-email">Email</th>
                            <th class="fix-header th-delete">{{ $t('Delete') }}</th>
                            <th class="fix-header th-setting">{{ $t('Decentralization') }}</th>
                            <th class="fix-header th-active">{{ $t('Activate') }}</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(userItem, index) in userList" :key="userItem.id">
                            <td class="td-id">{{ userItem.id }}</td>
                            <td class="td-fullname">{{ userItem.fullname }}</td>
                            <td class="td-userid">{{ userItem.userid }}</td>
                            <td class="td-position">{{ userItem.position }}</td>
                            <td class="td-area">{{ userItem.area }}</td>
                            <td class="td-hour">{{ userItem.hour }}</td>
                            <td class="td-email">{{ userItem.email }}</td>
                            <td class="td-delete">
                                <div class="icon-action"><i class="fas fa-times close-icon" @click="HandleDelete(userItem.userid, index)"></i></div>
                                <PopupDeleteUser v-bind:isActiveFormDelete="isActiveFormDelete" :userid="userIDSelected" v-on:signalHandleConfirm="handleConfirmDelete" v-on:signalHandleCancel="handleCancelDelete"></PopupDeleteUser>
                            </td>
                            <td class="td-setting">
                                <div class="icon-setting"><i class="fas fa-cog" @click="HandleSettings(userItem.userid, index)"></i></div>
                                <ComponentPrivilegeDetail v-bind:isActiveFormSetting="isActiveFormSetting[index]" :userid="userIDSelected" v-on:signalHandleCancel="handleCancelSettings" :indexID="index"></ComponentPrivilegeDetail>
                            </td>
                            <td class="td-active"><input type="checkbox" class="form-check-input" id="flexSwitchCheckDefault" v-model="isCheckPrivilege[index]" @click="handleCheckboxActive(userItem.userid, index)"></td>
                            <PopupActiveUser v-bind:isActiveFormVerify="isActiveFormVerify" :userid="userIDSelected" v-on:signalHandleConfirm="handleConfirmActive" v-on:signalHandleCancel="handleCancelActive"></PopupActiveUser>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="table_info">
                <div class="table_info_data">
                    {{$t('View')}} 1 - {{ this.userList.length }}
                </div>
            </div>
        </header>
    </div>
</div>
</template>

<script>
import axios from 'axios';
import ComponentPrivilegeDetail from './ComponentPrivilegeDetail.vue';
import PopupDeleteUser from './PopupDeleteUser.vue';
import PopupActiveUser from './PopupActiveUser.vue'
export default {
    components: {
        ComponentPrivilegeDetail,
        PopupDeleteUser,
        PopupActiveUser
    },
    props: {
        isActiveFormPrivilege: {
            type: Boolean,
            required: true,
            default: false
        },
    },
    data() {
        return {
            userList: [],
            isActiveFormDelete: false,
            isActiveFormSetting: [],
            isActiveFormVerify: false,
            userIDSelected: "",
            isCheckPrivilege: [],
            active_icon_loading: false,
            indexUserIDSelected: 0,
            privilegeUserIDSelect: false
        }
    },
    methods: {
        async HandleSearch() {
            const value = this.$refs.inputValue.value;
            this.$globalVariable.SEARCH_TEXT = value;
            console.log('[HandleSearch] value: ', value);
            if (value == "") {
                console.log('[HandleSearch] Warning: Please input value');
            } else {
                console.log('[HandleSearch] Info: Searching ...');

                this.active_icon_loading = true;
                this.userList = [];
                this.isCheckPrivilege = [];
                var path_data = 'E:\\Drive_W\\Data';
                if (this.$globalVariable.RUNNING_DOCKER) {
                    path_data = '/Data/Data';
                }

                const jsonData = {
                    name: value,
                    path: path_data,
                    userID: this.$globalVariable.USER_INFO.userID,
                    jobID: this.$globalVariable.USER_INFO.jobID,
                    areaID: this.$globalVariable.USER_INFO.areaID,
                };

                const jsonString = JSON.stringify(jsonData);
                console.log("[HandleSearch] jsonData: ", jsonData);
                console.log("[HandleSearch] jsonString: ", jsonString);
                await axios.post(this.$globalVariable.URL_API + '/ManageAccess/search_user/', jsonString, {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                }).then(response => {
                    console.log("(HandleSearch) response: ", response.data);
                const jsonString = response.data;
                console.log("(HandleSearch) userID: ", jsonString.userID);
                console.log("(HandleSearch) length: ", jsonString.data.length);

                for (let i = 0; i < jsonString.data.length; i++) {
                    const dataItem = jsonString.data[i];
                    var userItem = {
                        id: i + 1,
                        fullname: dataItem["fullName"],
                        userid: dataItem["userID"],
                        position: this.getPositionName(dataItem["jobID"]),
                        area: this.getAreaName(dataItem["areaID"]),
                        hour: this.getWorkName(dataItem["workID"], dataItem["kipID"]),
                        email: dataItem["email"],
                        delete: dataItem["id"],
                        setting: dataItem["id"],
                        isActive: dataItem["isActive"],
                    };
                    this.isCheckPrivilege[i] = dataItem["isActive"] == 1 ? true : false;
                    console.log("(HandleSearch) isCheckPrivilege at ", i, " = ", this.isCheckPrivilege[i]);
                    this.userList.push(userItem);
                }
                }).catch(error => {
                    console.error("[HandleSearch] error: ", error);
                })
                console.log("[HandleSearch] completed");
                this.active_icon_loading = false;
            }
        },
        handleCheckboxActive(userID, id) {
            console.log("(PopupActiveUser) [clicked] userID: ", userID, " and status: ", this.isCheckPrivilege[id], " and id: ", id);
            this.isActiveFormVerify = true;
            this.userIDSelected = userID;
            this.indexUserIDSelected = id;
            this.privilegeUserIDSelect = this.isCheckPrivilege[id];
        },
        async handleConfirmActive() {
            console.log("(PopupActiveUser) [confirm] userID: ", this.userIDSelected, " and status: ", this.isCheckPrivilege[this.indexUserIDSelected], " and id: ", this.indexUserIDSelected);
            const jsonData = {
                userID: this.userIDSelected,
                status: this.isCheckPrivilege[this.indexUserIDSelected]
            };
            const jsonString = JSON.stringify(jsonData);
            console.log("(PopupActiveUser) jsonString: ", jsonString);
            await axios.post(this.$globalVariable.URL_API + '/ManageAccess/active_account/', jsonString, {
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then(response => {
                console.log("(PopupActiveUser) response: ", response.data);
            }).catch(error => {
                console.error("(PopupActiveUser) error: ", error);
            })
            this.isActiveFormVerify = false;
        },
        handleCancelActive() {
            this.isActiveFormVerify = false;
            this.isCheckPrivilege[this.indexUserIDSelected] = !this.isCheckPrivilege[this.indexUserIDSelected];
            console.log("(PopupActiveUser) [cancel] userID: ", this.userIDSelected, " and status: ", this.isCheckPrivilege[this.indexUserIDSelected], " and id: ", this.indexUserIDSelected);
        },
        HandleDelete(userID, id) {
            console.log("(PopupDeleteUser) [clicked] userID: ", userID, " and id: ", id);
            this.isActiveFormDelete = true;
            this.userIDSelected = userID;
            this.indexUserIDSelected = id;
        },
        async handleConfirmDelete() {
            console.log("(PopupDeleteUser) [confirm] userID: ", this.userIDSelected, " and id: ", this.indexUserIDSelected);
            const jsonData = {
                userID: this.userIDSelected,
            };
            const jsonString = JSON.stringify(jsonData);
            console.log("(PopupDeleteUser) jsonString: ", jsonString);
            await axios.post(this.$globalVariable.URL_API + '/ManageAccess/delete_account/', jsonString, {
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then(response => {
                console.log("(PopupDeleteUser) response: ", response.data);
                if (response.data == "Error") {
                    console.error("(PopupDeleteUser) cannot delete user");
                } else {
                    this.userList = [];
                    const jsonString = response.data;
                    console.log("(PopupDeleteUser) userID: ", jsonString.userID);
                    console.log("(PopupDeleteUser) length: ", jsonString.data.length);

                    for (let i = 0; i < jsonString.data.length; i++) {
                        const dataItem = jsonString.data[i];
                        var userItem = {
                            id: i + 1,
                            fullname: dataItem["fullName"],
                            userid: dataItem["userID"],
                            position: this.getPositionName(dataItem["jobID"]),
                            area: this.getAreaName(dataItem["areaID"]),
                            hour: this.getWorkName(dataItem["workID"], dataItem["kipID"]),
                            email: dataItem["email"],
                            delete: dataItem["id"],
                            setting: dataItem["id"],
                            isActive: dataItem["isActive"],
                        };
                        this.isCheckPrivilege[i] = dataItem["isActive"] == 1 ? true : false;
                        console.log("(PopupDeleteUser) isCheckPrivilege at ", i, " = ", this.isCheckPrivilege[i]);
                        this.userList.push(userItem);
                    }
                }
            }).catch(error => {
                console.error("(PopupDeleteUser) error: ", error);
            })
            this.isActiveFormDelete = false;
        },
        handleCancelDelete() {
            this.isActiveFormDelete = false;
            console.log("(PopupDeleteUser) [cancel] userID: ", this.userIDSelected, " and id: ", this.indexUserIDSelected);
        },
        handleCancelSettings(index) {
            this.isActiveFormSetting[index] = false;
        },
        HandleSettings(userID, id) {
            console.log("HandleSettings: ", userID);
            this.userIDSelected = userID;
            this.isActiveFormSetting[id] = true;
            this.indexUserIDSelected = id;
        },
        HandleCancel() {
            this.$emit("signalCloseFormPrivilege");
        },
        getPositionName(id) {
            let result = "";
            switch (id) {
                case 1:
                    result = this.$t('DirectorDeputyDirector');
                    break;
                case 2:
                    result = this.$t('ForemanDeputyForeman');
                    break;
                case 3:
                    result = this.$t('InCharge');
                    break;
                case 4:
                    result = this.$t('Technician');
                    break;
                case 5:
                    result = this.$t('Operate');
                    break;
                case 6:
                    result = this.$t('Employee');
                    break;
                default:
                    result = "";
            }
            return result;
        },
        getAreaName(id) {
            let result = "";
            switch (id) {
                case 1:
                    result = this.$t('PXTSC');
                    break;
                case 2:
                    result = this.$t('PXHSM');
                    break;
                case 3:
                    result = this.$t('FurnaceArea');
                    break;
                case 4:
                    result = this.$t('WaterTreatment');
                    break;
                case 5:
                    result = "VP NM.CT QSP";
                    break;
                case 6:
                    result = "NM.CT HRC2";
                    break;
                default:
                    result = "";
            }
            return result;
        },
        getWorkName(workID, kipID) {
            let result = "";
            if (workID == 1) {
                result = this.$t('Administrative');
            } else if (workID == 2) {
                switch (kipID) {
                    case 1:
                        result = "Kip A";
                        break;
                    case 2:
                        result = "Kip B";
                        break;
                    case 3:
                        result = "Kip C";
                        break;
                    default:
                        result = "";
                }
            } else {
                result = "";
            }
            return result;
        },
        async handlePrivilege() {
            console.log("(handlePrivilege)");
            this.userList = [];
            const jsonData = {
                userID: this.$globalVariable.USER_INFO.userID,
            };
            const jsonString = JSON.stringify(jsonData);
            console.log("(handlePrivilege) jsonString: ", jsonString);
            await axios.post(this.$globalVariable.URL_API + '/ManageAccess/privilege/', jsonString, {
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then(response => {
                console.log("(handlePrivilege) response: ", response.data);
                const jsonString = response.data;
                console.log("(handlePrivilege) userID: ", jsonString.userID);
                console.log("(handlePrivilege) length: ", jsonString.data.length);

                for (let i = 0; i < jsonString.data.length; i++) {
                    const dataItem = jsonString.data[i];
                    var userItem = {
                        id: i + 1,
                        fullname: dataItem["fullName"],
                        userid: dataItem["userID"],
                        position: this.getPositionName(dataItem["jobID"]),
                        area: this.getAreaName(dataItem["areaID"]),
                        hour: this.getWorkName(dataItem["workID"], dataItem["kipID"]),
                        email: dataItem["email"],
                        delete: dataItem["id"],
                        setting: dataItem["id"],
                        isActive: dataItem["isActive"],
                    };
                    this.isCheckPrivilege[i] = dataItem["isActive"] == 1 ? true : false;
                    console.log("(handlePrivilege) isCheckPrivilege at ", i, " = ", this.isCheckPrivilege[i]);
                    this.userList.push(userItem);
                    console.log("(handlePrivilege) Array User List Push: ", this.userList);
                }
            }).catch(error => {
                console.error("(handlePrivilege) error: ", error);
            })
        }
    },
    computed: {

    },
    watch: {
        isActiveFormPrivilege(newValue, oldValue) {
            console.log('(handlePrivilege) (isActiveFormPrivilege) change from [', oldValue, '] to [', newValue, ']');
            if (oldValue == false && newValue == true) {
                this.handlePrivilege();
            }
        },
        userList(newValue, oldValue){
            console.log('(handlePrivilege) (userList) change from [', oldValue, '] to [', newValue, ']');
            for(let i = 0; i < this.userList.length; i++){
                this.isActiveFormSetting[i] = false;
            }
        }
    },
    mounted() {

    }
}
</script>

<style scoped>
.main {
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

.content {
    position: relative;
    font-family: Arial, Helvetica, sans-serif;
    background-color: #fff;
    padding: 0px;
    border: 4px;
    width: 93%;
    height: 80%;
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
    width: 48%;
}

.icon {
    text-align: right;
    cursor: pointer;
    margin-right: 10px;
    color: #fff;
    width: 48%;
}

.icon i {
    font-size: 20px;
    color: #fff;
}

.icon i:hover {
    font-size: 20px;
    color: #757575;
}

.menu-search {
    width: 100%;
    display: flexbox;
    border: none;
    margin-top: 0px;
    background-color: #fff;
    /* background: linear-gradient(to bottom, #B3E5FC, #fff); */
    height: 70px;
    padding-left: 20px;
    padding-top: 15px;
    overflow: hidden;
    align-items: right;
}

.content-search {
    border: 1px solid none;
    display: flex;
    float: right;
    padding-right: 20px;
}

.input {
    border: 1px solid #ccc;
    width: 400px;
    height: 40px;
    border-radius: 3px;
    padding: 10px;
    font-size: 16px;
    color: #333;
    margin-top: 1px;
    margin-bottom: 25px;
    margin-left: 14px;
    margin-right: 10px;
}

.input:focus {
    outline: none;
    border-color: #4caf50;
    box-shadow: 0 0 4px #4caf50;
}

.input.disabled {
    pointer-events: none;
    /* vô hiệu hóa tương tác với thẻ input khi bị disable */
    opacity: 0.9;
    /* giảm độ sáng cho thẻ input khi bị disable */
    background-color: bisque;
}

.open-popup {
    display: flex;
    border: 1px solid transparent;
    border-radius: 4px;
    height: 40px;
    font-family: Arial, Helvetica, sans-serif;
    font-size: 16px;
    cursor: pointer;
    background-color: transparent;
    margin-bottom: 1px;
    text-align: center;
    align-items: center;
    justify-content: center;
    padding: 10px;
    margin-right: 10px;
    text-decoration: none;
}

.open-popup:hover {
    border: 1px solid #64B5F6;
    background-color: #E3F2FD;
    transition: all 0.3s ease;
}

.icon-open-popup {
    display: inline-block;
    width: 24px;
    height: 24px;
    background-image: url(../assets/search.png);
    background-size: cover;
    background-position: center;
    margin-right: 10px;
    border: none;
}

.icon_loading {
    width: 24px;
    height: 24px;
    border: 1px solid none;
    background: transparent;
    color: #333;
    background-image: url('../assets/loading.gif');
    background-size: 24px;
    font-size: 24px;
    background-repeat: no-repeat;
    background-color: rgba(0, 0, 0, 0);
    margin-right: 10px;
}

.tab-table {
    position: absolute;
    display: flex;
    justify-content: center;
    align-items: center;
    border: none;
    background-color: #fff;
    width: 100%;
    height: calc(100% - 170px);
    overflow-y: auto;
    justify-content: center;
}

.custom-table {
    position: absolute;
    top: 0;
    width: 99%;
    min-width: 1500px;
    border-collapse: collapse;
    table-layout: fixed;
    padding: 10px;
    border: 1px solid red;
    float: inline-start;
    overflow-y: auto;
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
    padding: 8px;
    border: 1px solid #B5B5B5;
}

.th-id {
    /* width: 5%; */
    width: 40px;
}

.th-fullname {
    /* width: 17%; */
    width: 160px;
}

.th-userid {
    /* width: 12%; */
    width: 120px;
}

.th-position {
    /* width: 12%; */
    width: 140px;
}

.th-area {
    /* width: 12%; */
    width: 140px;
}

.th-hour {
    /* width: 10%; */
    width: 140px;
}

.th-email {
    /* width: 18%; */
    width: 200px;
}

.th-delete {
    /* width: 8%; */
    width: 90px;
}

.th-setting {
    /* width: 8%; */
    width: 90px;
}

.th-active {
    /* width: 8%; */
    width: 90px;
}

.td-id {
    text-align: center;
}
.td-userid {
    text-align: center;
}
.td-delete {
    text-align: center;
}

.td-setting {
    text-align: center;
}

.td-active {
    text-align: center;
}

.table_info {
    display: flexbox;
    bottom: 0;
    position: absolute;
    border: 2px solid #f2f2f2;
    height: 50px;
    width: 100%;
    padding: 12px;
    background: linear-gradient(to bottom, #CFD8DC, #FFF);
    align-items: right;
}

.table_info_data {
    float: right;
    font-family: Arial, Helvetica, sans-serif;
    border: none;
    text-align: right;
    padding-right: 20px;
}

.icon-action {
    cursor: pointer;
    margin-right: 10px;
    padding-left: 10px;
}

.icon-action i {
    font-size: 20px;
    color: red;
}

.icon-action i:hover {
    font-size: 20px;
    color: red;
}

.icon-setting {
    cursor: pointer;
    margin-right: 10px;
    padding-left: 10px;
}

.icon-setting i {
    font-size: 20px;
    color: #1976D2;
}

.icon-setting i:hover {
    font-size: 20px;
    color: #1976D2;
}
</style>
