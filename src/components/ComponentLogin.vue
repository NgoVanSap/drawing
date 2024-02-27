<template>
<div>
    <div class="sidenav">
        <div class="login-main-text">
            <h2>Đăng nhập</h2>
            <p>
                Bạn chưa có tài khoản, Vui lòng đăng ký
                <span @click="handleOpenRegister">Tại đây</span>
            </p>
        </div>
    </div>
    <div class="main">
        <div class="col-md-6 col-sm-12">
            <div class="login-form">
                <form @submit.prevent="handleSubmit">
                    <div class="form-group" style="margin-bottom: 15px;">
                        <label style="margin-bottom: 10px; color: #495057">Tài khoản</label>
                        <input type="text" class="form-control" v-model="username" @focus="removeMessage()" ref="inputValueUsername" :class="{'input-error': errorMessage.length > 0}" style="color: #495057" placeholder="Nhập MSNV" @keyup.enter="handleEnterPress" />
                    </div>
                    <div class="form-group mb-2" style="margin-bottom: 15px;">
                        <label style="margin-bottom: 10px; color: #495057">Mật khẩu</label>
                        <input type="password" class="form-control" v-model="password" @focus="removeMessage()" ref="inputValuePassword" :class="{'input-error': errorMessage.length > 0}" style="color: #495057" placeholder="Nhập mật khẩu" @keyup.enter="handleEnterPress" />
                    </div>
                    <span class="text-error" v-if="errorMessage.length > 0">{{ errorMessage}}</span>
                    <span class="text-error" v-if="warningMessage.length > 0">{{ warningMessage}}</span>
                    <div>
                        <button class="btn btn-secondary mt-2" :class="{ 'hovered': buttonHovered }" @click="handleLogin">Đăng nhập</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!--------SIGN IN--------->
    <v-row justify="center">
        <v-dialog v-model="dialog" persistent width="1024">
            <v-card>
                <v-form v-model="isForm" class="p-3">
                    <v-card-title>
                        <span class="text-h5" style="padding-bottom: 20px;">ĐĂNG KÝ TÀI KHOẢN</span>
                    </v-card-title>
                    <v-card-text>
                        <v-container>
                            <v-row>
                                <v-col cols="12" class="p-0">
                                    <v-text-field v-model="formData.name" label="Họ và tên*" :rules="[rules.required]"></v-text-field>
                                </v-col>
                                <v-col cols="12" class="p-0">
                                    <v-text-field v-model="formData.userID" label="Mã số nhân viên*" :rules="[rules.required]"></v-text-field>
                                </v-col>
                                <v-col cols="12" class="p-0">
                                    <v-select v-model="formData.jobPosition" :items="jobPositionItems" label="Vị trí công việc" persistent-hint return-object single-line></v-select>
                                </v-col>
                                <v-col cols="12" class="p-0">
                                    <v-select v-model="formData.area" :items="areaList" label="Khu vực làm việc" persistent-hint return-object single-line></v-select>
                                </v-col>
                                <v-col cols="12" class="p-0">
                                    <v-label>Giờ làm:</v-label>
                                    <v-radio-group column v-model="GioLam">
                                        <v-radio label="Hành chính" value="1"></v-radio>
                                        <v-radio label="Đi ca" value="2"></v-radio>
                                    </v-radio-group>
                                    <v-select v-model="formData.kip" :items="itemKIP" solo label="Chọn Ca" v-if="GioLam == 2" persistent-hint return-object single-line></v-select>
                                </v-col>
                                <v-col cols="12" class="p-0">
                                    <v-text-field v-model="formData.email" label="Email*" :rules="[rules.required, rules.email, rules.formatEmail]"></v-text-field>
                                </v-col>
                                <v-col cols="12" class="p-0">
                                    <v-text-field v-model="formData.pass" label="Password*" type="password" :rules="[rules.required]"></v-text-field>
                                </v-col>
                            </v-row>
                        </v-container>
                        <small>*là những trường bắt buộc</small>
                    </v-card-text>
                    <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn class="elevation-2" variant="text" @click="
                  dialog = false;
                  isSnackbar = false;
                " style="font-family: 'Poppins', sans-serif">
                            Đóng
                        </v-btn>
                        <v-btn class="elevation-2" variant="text" @click="handleRegister" style="font-family: 'Poppins', sans-serif">
                            Lưu
                        </v-btn>
                        <v-snackbar v-if="showSnackbar" v-model="showSnackbar" :color="snackbarColor" :timeout="2000">
                            {{ message }}
                        </v-snackbar>
                    </v-card-actions>
                </v-form>
            </v-card>
        </v-dialog>
    </v-row>
</div>
</template>

<script>
import moment from 'moment';
import axios from 'axios';
import {
    JOB_POSITION_ITEMS_REGISTER,
    AREA_LIST_RESGISTER
} from '../js/dataUser'
export default {
    components: {},
    data() {
        return {
            selectedOption: "option1",
            itemKIP: ["A", "B", "C"],
            GioLam: 1,
            textSnackbar: "",
            colorSnackbar: "",
            isSnackbar: false,
            isForm: false,
            username: null,
            password: null,
            loading: false,
            errorMessage: "",
            warningMessage: "",
            dialog: false,
            showSnackbar: false,
            formData: {
                name: "",
                pass: "",
                userID: "",
                email: "",
                jobPosition: null,
                status: 0,
                role: 1,
                kip: null,
                area: null,
            },
            jobPositionItems: JOB_POSITION_ITEMS_REGISTER,
            areaList: AREA_LIST_RESGISTER,
            rules: {
                required: (value) => !!value || "Bắt buộc.",
                email: (value) => {
                    const pattern =
                        /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                    return pattern.test(value) || "Email không hợp lệ.";
                },
                formatEmail: (value) =>
                    !!value.includes("hoaphat.com.vn") || "Email không thuộc công ty",
            },
            snackbar: false,
            message: "Đăng ký thành công",
            snackbarColor: "success",
            buttonHovered: false
        };
    },
    methods: {
        formatDate() {
            let datetime = new Date();
            return "[" + moment(datetime).format('DD-MM-YYYY HH:mm:ss.SSS') + "]";
        },
        handleEnterPress() {
            console.log(this.formatDate(), "(HandleLogin) handleEnterPress");
            this.buttonHovered = true;
        },
        clearDataUserLogin() {
            console.log(this.formatDate(), "(HandleLogin) clearDataUserLogin");
            this.$globalVariable.USER_INFO.id = 0;
            this.$globalVariable.USER_INFO.fullName = "";
            this.$globalVariable.USER_INFO.userID = "";
            this.$globalVariable.USER_INFO.email = "";
            this.$globalVariable.USER_INFO.password = "";
            this.$globalVariable.USER_INFO.jobID = 0;
            this.$globalVariable.USER_INFO.kipID = 0;
            this.$globalVariable.USER_INFO.workID = 0;
            this.$globalVariable.USER_INFO.areaID = 0;
            this.$globalVariable.USER_INFO.isActive = 0;
            this.$globalVariable.USER_INFO.language = 0;
            this.$globalVariable.USER_INFO.jobName = "";
            this.$globalVariable.USER_INFO.phone = "";
            this.$globalVariable.USER_INFO.admin = 0;
        },
        handleSubmit() {
            console.log(this.formatDate(), "(handleSubmit)");
        },
        async handleLogin() {

            console.log(this.formatDate(), "(HandleLogin) begin");
            const jsonData = {
                username: this.username,
                password: this.password
            };
            this.clearDataUserLogin();
            const jsonString = JSON.stringify(jsonData);
            console.log(this.formatDate(), "(HandleLogin) jsonData: ", jsonData);
            console.log(this.formatDate(), "(HandleLogin) jsonString: ", jsonString);
            await axios.post(this.$globalVariable.URL_API + '/ManageAccess/login/', jsonString, {
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then(response => {
                console.log(response.data);
                const data = response.data;
                const data_result = data["result"];
                console.log(this.formatDate(), "(HandleLogin) data_result: ", data_result);

                if (data_result == "success") {
                    console.log(this.formatDate(), "(HandleLogin) login passed");

                    this.isCheckViewListLayout = true;
                    console.log(this.formatDate(), "(HandleLogin) isCheckViewListLayout: ", this.isCheckViewListLayout);
                    console.log(this.formatDate(), "(HandleLogin) id: ", data["id"]);
                    console.log(this.formatDate(), "(HandleLogin) fullName: ", data["fullName"]);
                    console.log(this.formatDate(), "(HandleLogin) userID: ", data["userID"]);
                    console.log(this.formatDate(), "(HandleLogin) email: ", data["email"]);
                    console.log(this.formatDate(), "(HandleLogin) password: ", data["password"]);
                    console.log(this.formatDate(), "(HandleLogin) jobID: ", data["jobID"]);
                    console.log(this.formatDate(), "(HandleLogin) kipID: ", data["kipID"]);
                    console.log(this.formatDate(), "(HandleLogin) workID: ", data["workID"]);
                    console.log(this.formatDate(), "(HandleLogin) areaID: ", data["areaID"]);
                    console.log(this.formatDate(), "(HandleLogin) isActive: ", data["isActive"]);
                    console.log(this.formatDate(), "(HandleLogin) Language: ", data["language"]);
                    console.log(this.formatDate(), "(HandleLogin) jobName: ", data["jobName"]);
                    console.log(this.formatDate(), "(HandleLogin) phone: ", data["phone"]);
                    console.log(this.formatDate(), "(HandleLogin) admin: ", data["admin"]);

                    this.$globalVariable.USER_INFO.id = data["id"];
                    this.$globalVariable.USER_INFO.fullName = data["fullName"];
                    this.$globalVariable.USER_INFO.userID = data["userID"];
                    this.$globalVariable.USER_INFO.email = data["email"];
                    this.$globalVariable.USER_INFO.password = data["password"];
                    this.$globalVariable.USER_INFO.jobID = data["jobID"];
                    this.$globalVariable.USER_INFO.kipID = data["kipID"];
                    this.$globalVariable.USER_INFO.workID = data["workID"];
                    this.$globalVariable.USER_INFO.areaID = data["areaID"];
                    this.$globalVariable.USER_INFO.isActive = data["isActive"];
                    this.$globalVariable.USER_INFO.language = data["language"];
                    this.$globalVariable.USER_INFO.jobName = data["jobName"];
                    this.$globalVariable.USER_INFO.phone = data["phone"];
                    this.$globalVariable.USER_INFO.admin = data["admin"];

                    if (this.$globalVariable.USER_INFO.language == 1) {
                        this.$i18n.locale = 'en';
                        this.$globalVariable.TITLE_NUMBER_OF_FILE = this.$t('TITLE_NUMBER_OF_FILE');
                        if (this.isCheckViewListLayout == true) {
                            this.$globalVariable.TEXT_LAYOUT = this.$t('ListLayout');
                        } else {
                            this.$globalVariable.TEXT_LAYOUT = this.$t('GridLayout');
                        }
                    } else {
                        this.$i18n.locale = 'vi';
                        this.$globalVariable.TITLE_NUMBER_OF_FILE = "Số lượng tài liệu";
                        if (this.isCheckViewListLayout == true) {
                            this.$globalVariable.TEXT_LAYOUT = this.$t('ListLayout');
                        } else {
                            this.$globalVariable.TEXT_LAYOUT = this.$t('GridLayout');
                        }
                    }
                    this.$emit("signalLoginSuccess", {
                        username: this.username
                    });

                    // Khi người dùng đăng nhập hoặc thay đổi trạng thái ứng dụng
                    const appState = {
                        isLoggedIn: true, // Thay đổi dựa trên trạng thái đăng nhập
                        id: this.$globalVariable.USER_INFO.id,
                        fullName: this.$globalVariable.USER_INFO.fullName,
                        userID: this.$globalVariable.USER_INFO.userID,
                        email: this.$globalVariable.USER_INFO.email,
                        password: this.$globalVariable.USER_INFO.password,
                        jobID: this.$globalVariable.USER_INFO.jobID,
                        kipID: this.$globalVariable.USER_INFO.kipID,
                        workID: this.$globalVariable.USER_INFO.workID,
                        areaID: this.$globalVariable.USER_INFO.areaID,
                        isActive: this.$globalVariable.USER_INFO.isActive,
                        language: this.$globalVariable.USER_INFO.language,
                        jobName: this.$globalVariable.USER_INFO.jobName,
                        phone: this.$globalVariable.USER_INFO.phone,
                        admin: this.$globalVariable.USER_INFO.admin,
                        i18n_locale: this.$i18n.locale,
                        text_layout: this.$globalVariable.TEXT_LAYOUT
                    };

                    // Lưu trạng thái vào sessionStorage hoặc localStorage
                    window.sessionStorage.setItem('ManagerDrawState', JSON.stringify(appState));

                } else if (data_result == "waiting") {
                    console.log(this.formatDate(), "(HandleLogin) login waiting verify");
                    this.errorMessage = "Tài khoản đang chờ kích hoạt";
                } else {
                    console.log(this.formatDate(), "(HandleLogin) login failed");
                    this.errorMessage = "Tài khoản hoặc mật khẩu không đúng";
                }
            }).catch(error => {
                console.error(error);
                this.errorMessage = "Tài khoản hoặc mật khẩu không đúng";
            })
            console.log(this.formatDate(), "(HandleLogin) errorMessage: ", this.errorMessage);
            console.log(this.formatDate(), "(HandleLogin) warningMessage: ", this.warningMessage);
        },
        handleOpenRegister() {
            this.formData.name = "";
            this.formData.name = "";
            this.formData.pass = "";
            this.formData.userID = "";
            this.formData.email = "";
            this.formData.jobPosition = null;
            this.formData.status = 0;
            this.formData.role = 1;
            this.formData.kip = null;
            this.formData.area = null;
            this.dialog = true;
            console.log("(handleOpenRegister) Click: ", this.jobPositionItems);
        },
        async handleRegister() {
            console.log("(handleRegister)");
            console.log("(handleRegister) formData.name: ", this.formData.name);
            console.log("(handleRegister) formData.userID: ", this.formData.userID);
            console.log("(handleRegister) formData.email: ", this.formData.email);
            console.log("(handleRegister) formData.pass: ", this.formData.pass);
            console.log("(handleRegister) formData.jobPosition: ", this.formData.jobPosition);
            console.log("(handleRegister) formData.kip: ", this.formData.kip);
            console.log("(handleRegister) formData.area: ", this.formData.area);
            console.log("(handleRegister) GioLam: ", this.GioLam);

            if (!this.isForm) {
                console.log("(handleRegister) data is missing");
                this.message = "Đăng ký không thành công";
                this.snackbarColor = "red";
                this.showSnackbar = true;
            } else {
                let areaID = 0;
                switch (this.formData.area) {
                    case "PX. Đúc":
                        areaID = 1;
                        break;
                    case "PX. Cán":
                        areaID = 2;
                        break;
                    case "Khu vực Lò":
                        areaID = 3;
                        break;
                    case "Xử lý nước":
                        areaID = 4;
                        break;
                    case "VP NM.CT QSP":
                        areaID = 5;
                        break;
                    case "NM.CT HRC2":
                        areaID = 6;
                        break;
                    default:
                        areaID = 0;
                }

                let jobID = 0;
                switch (this.formData.jobPosition) {
                    case "Giám đốc/Phó giám đốc":
                        jobID = 1;
                        break;
                    case "Quản đốc/Phó quản đốc":
                        jobID = 2;
                        break;
                    case "Phụ trách":
                        jobID = 3;
                        break;
                    case "Kỹ thuật viên":
                        jobID = 4;
                        break;
                    case "Vận hành":
                        jobID = 5;
                        break;
                    case "Nhân viên":
                        jobID = 6;
                        break;
                    default:
                        jobID = 0;
                }

                let kipID = 0;
                switch (this.formData.kip) {
                    case "A":
                        kipID = 1;
                        break;
                    case "B":
                        kipID = 2;
                        break;
                    case "C":
                        kipID = 3;
                        break;
                    default:
                        kipID = 0;
                }

                console.log("(handleRegister) areaID: ", areaID);
                console.log("(handleRegister) jobID: ", jobID);
                console.log("(handleRegister) kipID: ", kipID);

                const jsonData = {
                    name: this.formData.name,
                    userID: this.formData.userID,
                    email: this.formData.email,
                    pass: this.formData.pass,
                    jobID: jobID,
                    kipID: kipID,
                    workID: this.GioLam,
                    areaID: areaID,
                };

                const jsonString = JSON.stringify(jsonData);
                console.log("(handleRegister) jsonData: ", jsonData);
                console.log("(handleRegister) jsonString: ", jsonString);
                await axios.post(this.$globalVariable.URL_API + '/ManageAccess/register/', jsonString, {
                    headers: {
                        'Content-Type': 'application/json'
                    }
                }).then(response => {
                    console.log(response.data);
                    if (response.data == "success") {
                        this.message = "Đăng ký thành công";
                        this.snackbarColor = "success";
                        this.dialog = false;
                        this.showSnackbar = false;
                    } else if (response.data == "exist") {
                        this.message = "Tên người dùng đã tồn tại";
                        this.snackbarColor = "red";
                        this.showSnackbar = true;
                    } else {
                        this.message = "Đăng ký không thành công";
                        this.snackbarColor = "red";
                        this.showSnackbar = true;
                    }
                }).catch(error => {
                    console.error(error);
                    this.message = "Đăng ký không thành công";
                    this.snackbarColor = "red";
                    this.showSnackbar = true;
                })
            }
        },
        removeMessage() {
            this.errorMessage = "";
            this.warningMessage = "";
            this.buttonHovered = false;
        },
        slotHandleClose() {
            console.log("(slotHandleClose)");
        },
        slotHandleSave() {
            console.log("(slotHandleSave)");
        }
    }
}
</script>

<style scoped>
@import '@mdi/font/css/materialdesignicons.min.css';

body {
    font-family: 'Poppins', sans-serif;
}

.v-radio .v-label {
    margin-bottom: 0px !important;
}

.main {
    padding: 0px 10px;
}

.main-head {
    height: 150px;
    background-color: #fff;
}

.sidenav {
    height: 100%;
    background-color: #000;
    overflow-x: hidden;
    padding-top: 20px;
}

.login-main-text {
    margin-top: 37%;
    padding: 60px;
    color: #fff;
}

.login-main-text h2 {
    font-weight: 300;
}

.login-main-text p span {
    cursor: pointer;
    color: #00f7f7;
    text-decoration: underline;
}

@media screen and (max-height: 450px) {
    .sidenav {
        padding-top: 15px;
    }
}

@media screen and (max-width: 450px) {
    .login-form {
        margin-top: 10%;
    }

    .register_form {
        margin-top: 10%;
    }
}

@media screen and (min-width: 768px) {
    .main {
        margin-left: 45%;
    }

    .sidenav {
        width: 40%;
        position: fixed;
        z-index: 1;
        top: 0;
        left: 0;
    }

    .login-form {
        margin-top: 80%;
    }

    .register_form {
        margin-top: 20%;
    }
}

.input-error {
    border: 1px solid #c03;
    background-color: #fce4e4;
}

.text-error {
    color: #c03;
    font-size: 13px;
}

.hovered {
  background-color: #5c636a;
}
</style>
