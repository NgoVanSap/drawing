<template>
  <div>
    <div
      v-if="isActive"
      class="node"
      @mouseover="showCellContent"
      @mouseout="hideCellContent"
    >
      <div class="content">
        <div class="content_expand">
          <i
            v-if="
              isMouseTreeNodeDirectory && this.isSubDirectory && this.isExpanded == false
            "
            class="icon_expand"
            @click="onClickIcon"
          ></i>
          <i
            v-if="isMouseTreeNodeDirectory && this.isSubDirectory && this.isExpanded"
            class="icon_unexpand"
            @click="onClickIcon"
          ></i>
        </div>
        <div class="content_text">
          <i
            v-if="!isLoading[node.id]"
            class="icon"
            :class="isExpanded ? 'fas fa-folder-open' : 'fas fa-folder'"
            @click="onClickIcon"
          ></i>
          <i
            v-if="isLoading[node.id]"
            class="icon"
            :class="'icon_loading'"
            @click="onClickIcon"
          ></i>
          <span
            :id="this.node.id"
            class="node_name"
            @click="makeBold"
            @click.left="handleLeftClick"
            @click.right="handleRightClick"
            >{{ node.name }}</span
          >
        </div>
      </div>
      <div v-if="showBookmark" class="bookmark">
        <label class="star-checkbox">
          <input type="checkbox" v-model="isChecked" />
          <span
            v-if="!statusBookmark"
            class="unchecked-star"
            :class="{ hover: isMouseOver }"
          ></span>
          <span v-if="statusBookmark" class="checked-star"></span>
        </label>
      </div>
    </div>
    <ul v-if="isExpanded">
      <tree-node
        v-for="childNode in node.children"
        :node="childNode"
        :childHightLight="childHightLight"
        :key="childNode.id"
        v-on:eventName="handleEmitTreeNodeItem"
        :isMouseTreeNodeDirectory="isMouseTreeNodeDirectory"
        :isLoading="isLoading"
        :isBrowse="isBrowse"
        v-on:signalUpdateTreeNodeItem="handleUpdateTreeNodeItem"
      ></tree-node>
    </ul>
  </div>
</template>

<script>
import moment from "moment";
import axios from "axios";
export default {
  props: {
    node: {
      type: Object,
      required: true,
    },
    isMouseTreeNodeDirectory: {
      type: Boolean,
      required: true,
      default: false,
    },
    isLoading: {
      type: Array,
      required: true,
    },
    childHightLight: {
      type: String,
      required: false,
    },
    isBrowse: {
      type: Boolean,
      required: true,
      default: false,
    },
  },
  data() {
    return {
      isExpanded: false,
      isChecked: false,
      isMouseOver: false,
      isActive: true,
      isSubDirectory: false,
    };
  },
  computed: {
    hasChildren() {
      return this.node.children && this.node.children.length > 0;
    },
    showBookmark() {
      if (this.node.name == "...") {
        return false;
      } else {
        return true;
      }
    },
    statusBookmark() {
      // console.log('(handleUpdateTreeNodeItem) (Tree_Node) bookmark name: ', this.node.name, ', status: ', this.node.bookmark);
      return this.node.bookmark;
    },
  },
  methods: {
    formatDate() {
      let datetime = new Date();
      return "[" + moment(datetime).format("DD-MM-YYYY HH:mm:ss.SSS") + "]";
    },
    handleUpdateTreeNodeItem(params) {
      console.log(
        this.formatDate(),
        "(handleUpdateTreeNodeItem) signalUpdateTreeNodeItemV2"
      );
      this.$emit("signalUpdateTreeNodeItem", params);
    },
    onClickIcon() {
      this.handleExpanded();
    },
    handleLeftClick(event) {
      // This is event Click on Left of the Mouse
      event.preventDefault();
    },
    handleRightClick(event) {
      // This is event Click on Right of the Mouse
      event.preventDefault();
    },
    showCellContent(event) {
      // This is event Mouse over on the item
      this.isMouseOver = true;
      event.preventDefault();
    },
    hideCellContent(event) {
      // This is event Mouse out of the item
      this.isMouseOver = false;
      event.preventDefault();
    },
    makeBold() {
      this.$emit("handleHighlightColor", {});
      this.handleExpanded();
    },
    async handleEmitTreeNodeItem(payload) {
      console.log(
        this.formatDate(),
        "Handle Tree Node Item emit from children: ",
        payload
      );
      await this.$emit("eventName", payload);
    },
    async handleExpanded() {
      console.log(this.formatDate(), "(Tree_Node_Click) begin");
      console.log(this.formatDate(), "(Tree_Node_Click) id: ", this.node.id);
      console.log(this.formatDate(), "(Tree_Node_Click) Name: ", this.node.name);
      console.log(this.formatDate(), "(Tree_Node_Click) FullName: ", this.node.fullName);
      console.log(this.formatDate(), "(Tree_Node_Click) isBrowse: ", this.isBrowse);
      console.log(this.formatDate(), "(Tree_Node_Click) hasChildren: ", this.hasChildren);
      console.log(this.formatDate(), "(Tree_Node_Click) isExpanded: ", this.isExpanded);
      if (this.isSubDirectory == false) {
        console.log(this.formatDate(), "(Tree_Node_Click) isExpanded => No Children");
      } else {
        console.log(this.formatDate(), "(Tree_Node_Click) isExpanded => Yes Children");
        this.isExpanded = !this.isExpanded;
      }
      console.log(this.formatDate(), "(Tree_Node_Click) isExpanded: ", this.isExpanded);
      console.log(
        this.formatDate(),
        "(Tree_Node_Click) isSubDirectory: ",
        this.isSubDirectory
      );

      if (this.isExpanded == false && this.isSubDirectory) {
        console.log(this.formatDate(), "(Tree_Node_Click) No request");
      } else {
        this.$globalVariable.SEARCH_TEXT = "";
        // Check directory name
        let directoryName = this.node.name;
        if (directoryName == "...") {
          console.log(
            this.formatDate(),
            "(Tree_Node_Click) fullName:",
            this.node.fullName
          );
          directoryName = this.node.fullName.split("\\");

          console.log(
            this.formatDate(),
            "(Tree_Node_Click) directoryName:",
            directoryName
          );
          if (directoryName.length > 0) {
            const lastItem = directoryName[directoryName.length - 1];
            directoryName = lastItem;
          }
        }
        // End check directory name

        await this.$emit("eventName", {
          id: this.node.id,
          name: directoryName,
          fullName: this.node.fullName,
          isBrowse: this.isBrowse,
        });
      }
    },
    async updateValueToDB(status) {
      const jsonData = {
        user_id: this.$globalVariable.USER_INFO.userID,
        name: this.node.name,
        location: this.node.fullName,
        type: 0,
        is_delete: !status,
      };

      const jsonString = JSON.stringify(jsonData);
      console.log(this.formatDate(), "(Tree_Node) tabSelected: ", this.node.tabSelected);
      console.log(this.formatDate(), "(Tree_Node) jsonData: ", jsonData);
      console.log(this.formatDate(), "(Tree_Node) jsonString: ", jsonString);
      await axios
        .post(this.$globalVariable.URL_API + "/Option/update_favorites/", jsonString, {
          headers: {
            "Content-Type": "application/json",
          },
        })
        .then((response) => {
          console.log(this.formatDate(), "(Tree_Node) response: ", response.data);
          // if(this.node.tabSelected == 2){
          console.log(
            this.formatDate(),
            "(handleUpdateTreeNodeItem) signalUpdateTreeNodeItemV1: ",
            this.node
          );
          this.$emit("signalUpdateTreeNodeItem", {
            name: this.node.name,
            location: this.node.fullName,
            status: status,
            isExpanded: this.node.isExpanded,
            tabSelected: this.node.tabSelected,
          });
          // }
        })
        .catch((error) => {
          console.error(this.formatDate(), "(Tree_Node) error: ", error);
        });
    },
  },
  watch: {
    isChecked(newValue, Oldvalue) {
      if (this.$globalVariable.isAllowUpdateBookmark) {
        // if (newValue == false || newValue == true) {
        if (this.node.isTabFavorites && newValue == false) {
          console.log(
            this.formatDate(),
            "(Tree_Node) (Tab_Favorites) isChecked of ",
            this.node.name,
            " (",
            this.node.fullName,
            ") ",
            " Change ",
            Oldvalue,
            "to",
            newValue,
            "and isTabFavorites: ",
            this.node.isTabFavorites
          );
          this.updateValueToDB(newValue);
        } else if (this.node.isTabFavorites == false) {
          console.log(
            this.formatDate(),
            "(Tree_Node) (Tab_Home) isChecked of ",
            this.node.name,
            " (",
            this.node.fullName,
            ") ",
            " Change ",
            Oldvalue,
            "to",
            newValue,
            "and isTabFavorites: ",
            this.node.isTabFavorites
          );
          this.updateValueToDB(newValue);
        }
        // }
        // console.log('(Tree_Node) (Tab_General) isLoading: ', this.isLoading);
        // console.log('(Tree_Node) (Tab_General) isChecked of ', this.node.name, ' (', this.node.fullName, ') ', ' Change ', Oldvalue, 'to', newValue, 'and isTabFavorites: ', this.node.isTabFavorites);
      } else {
        console.warn(
          this.formatDate(),
          "(Tree_Node) (Tab_General) isAllowUpdateBookmark: ",
          this.$globalVariable.isAllowUpdateBookmark
        );
      }
    },
    node(newValue, Oldvalue) {
      console.log(
        this.formatDate(),
        "(Tree_Node) node of ",
        this.node.name,
        " (",
        this.node.fullName,
        ") ",
        " Change ",
        Oldvalue,
        "to",
        newValue
      );
      if (this.childHightLight === newValue.name) {
        console.log("handleExpandedhandleExpanded");
        this.isExpanded = !this.isExpanded;
      }
    },
    childHightLight(newVal, oldVal) {
      console.log("childHightLight", newVal, oldVal, this.node);
      if (newVal === this.node.name) {
        console.log("handleExpandedhandleExpanded");
        this.isExpanded = !this.isExpanded;
      }
    },
  },
  beforeCreate() {
    // console.log('(Tree_Node) beforeCreate');
  },
  created() {
    // console.log('(Tree_Node) created');
    // console.log("nodenodenode", this.node);
  },
  beforeMount() {
    // console.log('(Tree_Node) beforeMount');
  },
  mounted() {
    // console.log('(Tree_Node) mounted ', this.node.name);
    this.isChecked = this.node.bookmark;
    this.isSubDirectory = this.node.isExpanded;
  },
  beforeUpdate() {
    // console.log('(Tree_Node) beforeUpdate');
  },
  updated() {
    // console.log('(handleUpdateTreeNodeItem) (Tree_Node) bookmark name: ', this.node.name, ', status: ', this.node.bookmark);
  },
  beforeUnmount() {
    // console.log('(Tree_Node) beforeUnmount');
  },
  Unmounted() {
    // console.log('(Tree_Node) Unmounted');
  },
};
</script>

<style scoped>
@import "~@fortawesome/fontawesome-free/css/all.css";

.node {
  display: flex;
  flex-direction: row;
  font-family: "Roboto", sans-serif;
  font-size: 14px;
  cursor: pointer;
  white-space: nowrap;
  border: 1px solid transparent;
  height: 30px;
  justify-content: space-between;
  width: 100%;
}
.content {
  display: flex;
  flex-direction: row;
  border: 1px solid transparent;
}
.fa-folder:before {
  content: "\f07b";
  color: #f8d775;
  margin-right: 5px;
}

.fa-folder-open:before {
  content: "\f07c";
  color: #f8d775;
  margin-right: 5px;
}
.content_text {
  position: relative;
  display: flex;
  border: 1px solid transparent;
  height: 30px;
  min-width: 100px;
}
.content_text:hover {
  background-color: #f2f2f2;
}
.icon {
  display: flex;
  border: 1px solid transparent;
  padding-left: 5px;
  padding-top: 5px;
}

.node_name {
  display: flex;
  border: 1px solid transparent;
  white-space: nowrap;
  padding-top: 2px;
}

.node:hover {
  background-color: #f2f2f2;
}

.bookmark {
  display: flex;
  margin-left: 10px;
  border: 1px solid transparent;
  float: right;
}
.star-checkbox {
  display: inline-block;
  position: relative;
  cursor: pointer;
  font-size: 0;
  border: 1px solid transparent;
  width: 30px;
  height: 30px;
  padding-top: 1px;
}

.unchecked-star,
.checked-star {
  cursor: pointer;
  position: relative;
  display: inline-block;
  width: 20px;
  height: 20px;
  margin: 0 2px;
  background-color: transparent;
  border: 2px solid white;
  clip-path: polygon(
    50% 0%,
    61.8% 35.3%,
    98.2% 35.3%,
    68.2% 57.3%,
    79.1% 91.7%,
    50% 70.7%,
    20.9% 91.7%,
    31.8% 57.3%,
    1.8% 35.3%,
    38.2% 35.3%
  );
}

.unchecked-star::before {
  content: "\2605";
  /* Điểm mã Unicode cho ngôi sao đầy */
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  color: white;
  /* Màu của ngôi sao đầy */
  font-size: 22px;
  /* Kích thước của ngôi sao đầy */
  line-height: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  visibility: visible;
  cursor: pointer;
}

.unchecked-star.hover::before {
  content: "\2605";
  /* Điểm mã Unicode cho ngôi sao đầy */
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  color: grey;
  /* Màu của ngôi sao đầy */
  font-size: 22px;
  /* Kích thước của ngôi sao đầy */
  line-height: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  visibility: visible;
  cursor: pointer;
}

.checked-star::before {
  content: "\2605";
  /* Điểm mã Unicode cho ngôi sao đầy */
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  color: #c0ca33;
  /* Màu của ngôi sao đầy */
  font-size: 20px;
  /* Kích thước của ngôi sao đầy */
  line-height: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  visibility: visible;
  cursor: pointer;
}

input[type="checkbox"] {
  position: absolute;
  opacity: 0;
}

/* input[type="checkbox"]:checked+.checked-star::before {
    visibility: visible;
}

input[type="checkbox"]:not(:checked)+.unchecked-star::before {
    visibility: visible;
} */

.content_expand {
  position: relative;
  display: flex;
  width: 20px;
  height: 30px;
  border: 1px solid transparent;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding-top: 0px;
  padding-bottom: 5px;
}

.icon_expand {
  display: flex;
  width: 20px;
  height: 20px;
  background-image: url(../assets/images/expand.png);
  background-size: cover;
  background-position: center;
  border: 1px solid transparent;
}

.icon_unexpand {
  display: flex;
  width: 20px;
  height: 20px;
  background-image: url(../assets/images/unexpand.png);
  background-size: cover;
  background-position: center;
  border: 1px solid transparent;
}

.icon_loading {
  display: flex;
  text-align: center;
  justify-content: center;
  align-items: center;
  width: 20px;
  height: 20px;
  border: 1px solid transparent;
  background: transparent;
  color: #333;
  background-image: url("../assets/loading.gif");
  background-size: 20px;
  font-size: 24px;
  background-repeat: no-repeat;
  background-color: rgba(0, 0, 0, 0);
  margin-right: 7px;
}
</style>
