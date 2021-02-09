<template>
  <div class="container">
    <div class="row">
      <div class="col-sm-10">
        <h1>Hosts</h1>
        <hr><br><br>
        <alert :message=message v-if="showMessage"></alert>
        <button type="button" class="btn btn-success btn-sm" v-b-modal.hosts-modal>Add Hosts</button>
        <br><br>
        <table class="table table-hover">
          <thead>
            <tr>
              <th scope="col">Host Name</th>
              <th scope="col">IP Address</th>
              <th scope="col">Uptime</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(host, index) in hosts" :key="index">
              <td>{{ host.host_name }}</td>
              <td>{{ host.ip_address }}</td>
              <td>{{ host.uptime }}</td>
              <td>
                <span v-if="host.read">Yes</span>
                <span v-else>No</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    <b-modal ref="addHostsModal"
             id="host-modal"
             title="Add a new host"
             hide-footer>
      <b-form @submit="onSubmit" @reset="onReset" class="w-100">
      <b-form-group id="form-title-group"
                    label="Title:"
                    label-for="form-title-input">
          <b-form-input id="form-title-input"
                        type="text"
                        v-model="addHostsForm.host_name"
                        required
                        placeholder="Enter host_name">
          </b-form-input>
        </b-form-group>
        <b-form-group id="form-author-group"
                      label="Author:"
                      label-for="form-author-input">
            <b-form-input id="form-author-input"
                          type="text"
                          v-model="addHostsForm.author"
                          required
                          placeholder="Enter author">
            </b-form-input>
          </b-form-group>
        <b-form-group id="form-read-group">
          <b-form-checkbox-group v-model="addHostsForm.read" id="form-checks">
            <b-form-checkbox value="true">Read?</b-form-checkbox>
          </b-form-checkbox-group>
        </b-form-group>
        <b-button type="submit" variant="primary">Submit</b-button>
        <b-button type="reset" variant="danger">Reset</b-button>
      </b-form>
    </b-modal>
    <b-modal ref="editHostsModal"
             id="host-update-modal"
             title="Update"
             hide-footer>
      <b-form @submit="onSubmitUpdate" @reset="onResetUpdate" class="w-100">
      <b-form-group id="form-title-edit-group"
                    label="Title:"
                    label-for="form-title-edit-input">
          <b-form-input id="form-title-edit-input"
                        type="text"
                        v-model="editForm.title"
                        required
                        placeholder="Enter title">
          </b-form-input>
        </b-form-group>
        <b-form-group id="form-author-edit-group"
                      label="Author:"
                      label-for="form-author-edit-input">
            <b-form-input id="form-author-edit-input"
                          type="text"
                          v-model="editForm.author"
                          required
                          placeholder="Enter author">
            </b-form-input>
          </b-form-group>
        <b-form-group id="form-read-edit-group">
          <b-form-checkbox-group v-model="editForm.read" id="form-checks">
            <b-form-checkbox value="true">Read?</b-form-checkbox>
          </b-form-checkbox-group>
        </b-form-group>
        <b-button type="submit" variant="primary">Update</b-button>
        <b-button type="reset" variant="danger">Cancel</b-button>
      </b-form>
    </b-modal>
  </div>
</template>

<script>
import axios from 'axios';
import Alert from './Alert';

export default {
  data() {
    return {
      hosts: [],
      addHostsForm: {
        host_name: '',
        ip_address: '',
        read: [],
      },
      editForm: {
        id: '',
        title: '',
        author: '',
        read: [],
      },
      message: '',
      showMessage: false,
      ROOT_API: process.env.ROOT_API,
    };
  },
  components: {
    alert: Alert,
  },
  methods: {
    getHosts() {
      const path = `${this.ROOT_API}/hosts`;
      axios.get(path)
        .then((res) => {
          this.hosts = res.data.hosts;
        })
        .catch((error) => {
          // eslint-disable-next-line
          console.error(error);
        });
    },
    addHosts(payload) {
      const path = `${this.ROOT_API}/hosts`;
      axios.post(path, payload)
        .then(() => {
          this.getHosts();
          this.message = 'Hosts added!';
          this.showMessage = true;
        })
        .catch((error) => {
          // eslint-disable-next-line
          console.error(error);
          this.getHosts();
        });
    },
    updateHosts(payload, hostID) {
      const path = `${this.ROOT_API}/hosts/${hostID}`;
      axios.put(path, payload)
        .then(() => {
          this.getHosts();
          this.message = 'Hosts updated!';
          this.showMessage = true;
        })
        .catch((error) => {
          // eslint-disable-next-line
          console.error(error);
          this.getHosts();
        });
    },
    removeHosts(hostID) {
      const path = `${this.ROOT_API}/hosts/${hostID}`;
      axios.delete(path)
        .then(() => {
          this.getHosts();
          this.message = 'Hosts removed!';
          this.showMessage = true;
        })
        .catch((error) => {
          // eslint-disable-next-line
          console.error(error);
          this.getHosts();
        });
    },
    initForm() {
      this.addHostsForm.host_name = '';
      this.addHostsForm.ip_address = '';
      this.addHostsForm.uptime = '';
      this.editForm.id = '';
      this.editForm.host_name = '';
      this.editForm.ip_address = '';
      this.editForm.uptime = '';
    },
    onSubmit(evt) {
      evt.preventDefault();
      this.$refs.addHostsModal.hide();
      let read = false;
      if (this.addHostsForm.read[0]) read = true;
      const payload = {
        host_name: this.addHostsForm.host_name,
        ip_address: this.addHostsForm.ip_address,
        uptime: this.addHostsForm.uptime,
        read, // property shorthand
      };
      this.addHosts(payload);
      this.initForm();
    },
    onSubmitUpdate(evt) {
      evt.preventDefault();
      this.$refs.editHostsModal.hide();
      let read = false;
      if (this.editForm.read[0]) read = true;
      const payload = {
        title: this.editForm.title,
        author: this.editForm.author,
        read,
      };
      this.updateHosts(payload, this.editForm.id);
    },
    onReset(evt) {
      evt.preventDefault();
      this.$refs.addHostsModal.hide();
      this.initForm();
    },
    onResetUpdate(evt) {
      evt.preventDefault();
      this.$refs.editHostsModal.hide();
      this.initForm();
      this.getHosts(); // why?
    },
    onDeleteHosts(hosts) {
      this.removeHosts(host.id);
    },
    editHosts(hosts) {
      this.editForm = hosts;
    },
  },
  created() {
    this.getHosts();
  },
  mounted: function () {
    this.$nextTick(function () {
      setInterval(async () => {
          this.getHosts();
      }, 15);
    })
  },
};
</script>
